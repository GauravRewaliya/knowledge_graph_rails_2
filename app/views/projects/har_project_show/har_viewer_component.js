  const HarViewer = {
    props: ['onAddHar'],
    components: { JsonViewer },
    setup(props) {
      const { ref, computed, onMounted, onUnmounted, watch } = Vue;
      const store = window.projectStore;

      // Local State
      const filter = ref('');
      const viewType = ref('TABLE');
      const selectedId = ref(null);
      const groupMode = ref('NONE');
      const expandedGroups = ref(new Set());
      const showDeleteConfirm = ref(false);
      const curlCopied = ref(false);
      const syncedMsg = ref(false);

      // Computed
      const entries = computed(() => store?.activeProject?.harEntries || []);
      
      const selectedEntry = computed(() => 
        entries.value.find(e => e.id === selectedId.value)
      );

      const selectedJson = computed(() => {
        if (!selectedEntry.value?.response?.content?.text) return null;
        try {
          return JSON.parse(selectedEntry.value.response.content.text);
        } catch {
          return null;
        }
      });

      const filteredEntries = computed(() => {
        if (!filter.value) return entries.value;
        const lower = filter.value.toLowerCase();
        return entries.value.filter(e => e.request.url.toLowerCase().includes(lower));
      });

      const flatTree = computed(() => {
        if (groupMode.value === 'NONE') {
          return filteredEntries.value.map(e => ({ type: 'ENTRY', data: e }));
        }
        
        // Grouping logic would go here, simplified for now
        return filteredEntries.value.map(e => ({ type: 'ENTRY', data: e }));
      });

      const selectedCount = computed(() => entries.value.filter(e => e._selected).length);
      const isAllDisplayedSelected = computed(() => 
        filteredEntries.value.length > 0 && filteredEntries.value.every(e => e._selected)
      );

      // Time calculations
      const startTime = computed(() => 
        entries.value.length ? Math.min(...entries.value.map(e => new Date(e.startedDateTime).getTime())) : 0
      );
      const endTime = computed(() => 
        entries.value.length ? Math.max(...entries.value.map(e => new Date(e.startedDateTime).getTime() + e.time)) : 0
      );
      const totalDuration = computed(() => (endTime.value - startTime.value) || 1);

      // Methods
      const toggleSelection = (id) => {
        const entry = entries.value.find(e => e.id === id);
        if (entry) entry._selected = !entry._selected;
      };

      const toggleAll = () => {
        const targetState = !isAllDisplayedSelected.value;
        filteredEntries.value.forEach(e => e._selected = targetState);
      };

      const handleDeleteClick = () => {
        if (selectedCount.value > 0) showDeleteConfirm.value = true;
      };

      const confirmDelete = () => {
        const toDelete = entries.value.filter(e => e._selected).map(e => e.id);
        toDelete.forEach(id => store.removeHarFile(id));
        setSelectedId(null);
        showDeleteConfirm.value = false;
      };

      const setSelectedId = (id) => {
        selectedId.value = id;
      };

      const getMethodColor = (method) => {
        switch (method) {
          case 'GET': return 'method-get';
          case 'POST': return 'method-post';
          case 'PUT': return 'method-put';
          case 'DELETE': return 'method-delete';
          default: return 'method-default';
        }
      };

      const formatBytes = (bytes) => {
        if (!+bytes) return '0 KB';
        return (bytes / 1024).toFixed(1) + ' KB';
      };

      const getUrlPath = (url) => {
        try {
          return url.split('?')[0].split('/').slice(-2).join('/');
        } catch {
          return url;
        }
      };

      const handleCopyCurl = () => {
        if (selectedEntry.value) {
            const cmd = HarUtils.generateCurlCommand(selectedEntry.value.request);
            navigator.clipboard.writeText(cmd);
            curlCopied.value = true;
            setTimeout(() => curlCopied.value = false, 2000);
        }
      };

      return {
        filter, viewType, selectedId, groupMode, showDeleteConfirm,
        entries, flatTree, selectedEntry, selectedJson, selectedCount,
        isAllDisplayedSelected, startTime, totalDuration, curlCopied,
        toggleSelection, toggleAll, handleDeleteClick, confirmDelete,
        setSelectedId, getMethodColor, formatBytes, getUrlPath, handleCopyCurl
      };
    },
    template: `
      <div class="har-container">
        <!-- Delete Modal -->
        <div v-if="showDeleteConfirm" class="har-modal-overlay">
            <div class="har-modal">
                <div class="har-modal-header">
                    <icon name="trash" size="24"></icon>
                    <h3 class="har-modal-title">Confirm Deletion</h3>
                </div>
                <p style="color: var(--gray-300); margin-bottom: 1.5rem;">
                    Delete <span style="font-weight: bold; color: var(--white);">{{ selectedCount }}</span> entries?
                </p>
                <div class="har-modal-actions">
                    <button @click="showDeleteConfirm = false" class="btn-cancel">Cancel</button>
                    <button @click="confirmDelete" class="btn-delete">Delete</button>
                </div>
            </div>
        </div>

        <!-- Left Panel -->
        <div :class="['har-left-panel', selectedId ? 'split' : '']">
          <!-- Toolbar -->
          <div class="har-toolbar">
              <div class="har-search-bar">
                  <div class="search-input-wrapper">
                      <icon name="search" class="search-icon"></icon>
                      <input
                          type="text"
                          placeholder="Filter requests..."
                          class="search-input"
                          v-model="filter"
                      />
                  </div>
                  <button 
                      @click="$emit('add-har')"
                      class="btn-add-har"
                  >
                      <icon name="file-plus" size="16"></icon> Add HAR
                  </button>
              </div>
              
              <div class="har-controls">
                  <div class="control-group">
                      <button @click="toggleAll" class="btn-text">
                          <icon :name="isAllDisplayedSelected ? 'check-square' : 'square'" size="14" :class="isAllDisplayedSelected ? 'text-blue-500' : ''"></icon>
                          All
                      </button>
                      
                      <div class="select-group">
                          <span style="color: var(--gray-500);">Group:</span>
                          <select 
                              v-model="groupMode"
                              class="har-select"
                          >
                              <option value="NONE">None</option>
                              <option value="FILE">By File</option>
                              <option value="ENDPOINT">By Endpoint</option>
                          </select>
                      </div>

                      <div class="view-toggle">
                          <button @click="viewType = 'TABLE'" :class="['btn-icon', viewType === 'TABLE' ? 'active' : '']"><icon name="layers" size="12"></icon></button>
                          <button @click="viewType = 'WATERFALL'" :class="['btn-icon', viewType === 'WATERFALL' ? 'active' : '']"><icon name="clock" size="12"></icon></button>
                      </div>
                  </div>
                  
                  <div class="control-group">
                      <button 
                          @click="handleDeleteClick" 
                          class="btn-text"
                          style="color: var(--red-600);"
                          :disabled="selectedCount === 0"
                      >
                          <icon name="trash" size="12"></icon> {{ selectedCount }}
                      </button>
                  </div>
              </div>
          </div>

          <!-- List Content -->
          <div class="har-list" tabindex="0">
              <div v-if="flatTree.length === 0" class="empty-state">No entries found</div>
              <div v-else>
                  <div v-for="item in flatTree" :key="item.data.id">
                      <!-- Entry Row -->
                      <div 
                          v-if="item.type === 'ENTRY'"
                          :class="['har-entry-row', selectedId === item.data.id ? 'selected' : '']"
                          @click="setSelectedId(item.data.id)"
                      >
                          <div class="checkbox-col" @click.stop="toggleSelection(item.data.id)">
                              <icon :name="item.data._selected ? 'check-square' : 'square'" size="14" :style="{ color: item.data._selected ? 'var(--blue-500)' : 'var(--gray-500)' }"></icon>
                          </div>

                          <div class="entry-content">
                               <div class="entry-meta">
                                  <span :class="['method-badge', getMethodColor(item.data.request.method)]">{{ item.data.request.method }}</span>
                                  <span :class="['status-code', item.data.response.status < 400 ? 'status-success' : 'status-error']">{{ item.data.response.status }}</span>
                                  <span class="size-text">{{ formatBytes(item.data.response.content.size) }}</span>
                               </div>
                               
                               <div class="entry-url-row">
                                  <div class="url-text" :title="item.data.request.url">
                                      {{ getUrlPath(item.data.request.url) }}
                                  </div>
                                  <div class="time-text">{{ Math.round(item.data.time) }}ms</div>
                               </div>

                               <div v-if="viewType === 'WATERFALL'" class="waterfall-container">
                                   <div class="waterfall-bar" 
                                        :style="{ 
                                          left: ((new Date(item.data.startedDateTime).getTime() - startTime) / totalDuration * 100) + '%', 
                                          width: Math.max((item.data.time / totalDuration * 100), 0.5) + '%' 
                                        }">
                                   </div>
                               </div>
                          </div>
                      </div>
                  </div>
              </div>
          </div>
        </div>

        <!-- Right Panel: Details -->
        <div v-if="selectedId && selectedEntry" class="har-details-panel">
           <div class="details-header">
               <div class="details-title-group">
                  <h3 class="details-url" :title="selectedEntry.request.url">{{ selectedEntry.request.url }}</h3>
                  <div class="details-meta">
                       <span>{{ selectedEntry.request.method }}</span>
                  </div>
               </div>
               <div class="control-group">
                   <button 
                      @click="handleCopyCurl"
                      class="btn-icon"
                      title="Copy as cURL"
                   >
                      <span v-if="curlCopied" style="color: #4ade80; font-size: 10px;">Copied</span>
                      <icon v-else name="terminal" size="16"></icon>
                   </button>
                   <button @click="setSelectedId(null)" class="btn-icon" title="Close"><icon name="arrow-right" size="18"></icon></button>
               </div>
           </div>
           <div class="details-content">
              <div>
                  <h4 class="section-title">Request Headers</h4>
                  <div class="headers-box">
                      <div v-for="(h, i) in selectedEntry.request.headers.slice(0, 5)" :key="i" class="header-row">
                        <span class="header-name">{{ h.name }}:</span>
                        <span class="header-value">{{ h.value.substring(0, 100) }}</span>
                      </div>
                  </div>
              </div>
              <div style="flex: 1; display: flex; flex-direction: column;">
                  <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                      <h4 class="section-title" style="margin: 0;">Response Body</h4>
                      <span style="font-size: 0.75rem; color: var(--gray-500);">{{ formatBytes(selectedEntry.response.content.size) }}</span>
                  </div>
                  <div class="response-box">
                       <json-viewer v-if="selectedJson" :data="selectedJson" :initial-expanded="true"></json-viewer>
                       <pre v-else class="response-pre">{{ selectedEntry.response.content.text || '<No Content>' }}</pre>
                  </div>
              </div>
           </div>
        </div>
      </div>
    `
  };
