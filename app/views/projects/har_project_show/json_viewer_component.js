  const JsonViewer = {
    name: 'JsonViewer',
    props: {
      data: [Object, Array, String, Number, Boolean, null],
      label: String,
      initialExpanded: { type: Boolean, default: false },
      isRoot: { type: Boolean, default: false }
    },
    // Icon is registered globally
    setup(props) {
      const { ref, computed, onMounted } = Vue;
      const expanded = ref(props.initialExpanded);
      const copied = ref(false);
      const rowRef = ref(null);

      const isObject = computed(() => props.data !== null && typeof props.data === 'object');
      const isArray = computed(() => Array.isArray(props.data));
      const isEmpty = computed(() => isObject.value && Object.keys(props.data).length === 0);

      const handleCopy = (e) => {
        e.stopPropagation();
        navigator.clipboard.writeText(JSON.stringify(props.data, null, 2));
        copied.value = true;
        setTimeout(() => copied.value = false, 2000);
      };

      const toggle = () => {
        if (isObject.value && !isEmpty.value) expanded.value = !expanded.value;
      };

      // Helper to get all focusable rows in the DOM (that are visible)
      const getVisibleRows = () => {
        return Array.from(document.querySelectorAll('[data-json-nav]'));
      };

      const handleKeyDown = (e) => {
        // Only handle navigation keys
        if (!['ArrowDown', 'ArrowUp', 'ArrowLeft', 'ArrowRight', 'Enter', ' '].includes(e.key)) {
            return;
        }

        e.preventDefault();
        e.stopPropagation();

        const currentRow = e.currentTarget;

        // Enter/Space: Toggle
        if (e.key === 'Enter' || e.key === ' ') {
            toggle();
            return;
        }

        if (e.key === 'ArrowDown') {
            const rows = getVisibleRows();
            const idx = rows.indexOf(currentRow);
            if (idx !== -1 && idx < rows.length - 1) {
                rows[idx + 1].focus();
            }
        }

        if (e.key === 'ArrowUp') {
            const rows = getVisibleRows();
            const idx = rows.indexOf(currentRow);
            if (idx > 0) {
                rows[idx - 1].focus();
            }
        }

        if (e.key === 'ArrowRight') {
            if (isObject.value && !isEmpty.value && !expanded.value) {
                // Expand
                expanded.value = true;
            } else {
                // Go to next item
                if (isObject.value && !isEmpty.value && expanded.value) {
                    const rows = getVisibleRows();
                    const idx = rows.indexOf(currentRow);
                    if (idx !== -1 && idx < rows.length - 1) {
                        rows[idx + 1].focus();
                    }
                } else {
                    const rows = getVisibleRows();
                    const idx = rows.indexOf(currentRow);
                    if (idx !== -1 && idx < rows.length - 1) {
                        rows[idx + 1].focus();
                    }
                }
            }
        }

        if (e.key === 'ArrowLeft') {
            if (isObject.value && !isEmpty.value && expanded.value) {
                // Collapse
                expanded.value = false;
            } else {
                // Move to parent
                const parentContainer = currentRow.parentElement?.closest('.json-tree-children');
                if (parentContainer) {
                     const parentRow = parentContainer.previousElementSibling;
                     if (parentRow && parentRow.hasAttribute('data-json-nav')) {
                         parentRow.focus();
                     }
                }
            }
        }
      };

      return {
        expanded, copied, rowRef, isObject, isArray, isEmpty,
        handleCopy, toggle, handleKeyDown
      };
    },
    template: `
      <div v-if="!isObject" 
        ref="rowRef"
        data-json-nav="true"
        tabindex="0"
        @keydown="handleKeyDown"
        class="json-primitive-row"
      >
        <span v-if="label" class="json-key">{{ label }}:</span>
        <span :class="[
          'json-value',
          typeof data === 'string' ? 'json-string' : '',
          typeof data === 'number' ? 'json-number' : '',
          typeof data === 'boolean' ? 'json-bool' : '',
          data === null ? 'json-null' : ''
        ]">
          {{ typeof data === 'string' ? '"' + data + '"' : String(data) }}
        </span>
      </div>

      <div v-else class="json-object-container">
        <div 
          ref="rowRef"
          data-json-nav="true"
          tabindex="0"
          @keydown="handleKeyDown"
          @click.stop="toggle"
          :class="['json-object-row', isEmpty ? 'cursor-default' : '']"
        >
          <div v-if="isObject && !isEmpty" class="json-toggle-icon">
             <icon :name="expanded ? 'chevron-down' : 'chevron-right'" size="12" style="color: var(--gray-500);"></icon>
          </div>
          <div v-else class="w-3"></div>
          
          <span v-if="label" class="json-key">{{ label }}:</span>
          
          <span class="json-bracket">
            {{ isArray ? '[' : '{' }}
            <span v-if="!expanded && !isEmpty" class="json-ellipsis">...</span>
            <span v-if="isEmpty">{{ isArray ? ']' : '}' }}</span>
          </span>
          
          <span v-if="!isEmpty && !expanded" class="json-meta">
            {{ isArray ? data.length + ' items' : Object.keys(data).length + ' keys' }}
          </span>

          <button @click="handleCopy" class="json-copy-btn">
              <span v-if="copied" class="text-green-500 text-[10px]">Copied</span>
              <icon v-else name="copy" size="10"></icon>
          </button>
        </div>

        <div v-if="expanded && !isEmpty" class="json-tree-children">
           <template v-if="isArray">
               <json-viewer v-for="(item, idx) in data" :key="idx" :data="item" :label="String(idx)"></json-viewer>
           </template>
           <template v-else>
               <json-viewer v-for="(value, key) in data" :key="key" :data="value" :label="key"></json-viewer>
           </template>
           <div class="json-bracket-close">{{ isArray ? ']' : '}' }}</div>
        </div>
      </div>
    `
  };
