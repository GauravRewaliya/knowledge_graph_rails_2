window.projectStore = Vue.reactive({
  activeProject: null,
  viewMode: 'UPLOAD',
  isChatOpen: false,

  init() {
    // Simulate loading project
    // In a real app, this might fetch from an API
    this.activeProject = {
      harEntries: [],
      knowledgeData: { nodes: [], links: [] }
    };
  },

  async addHarFile(file) {
    if (!this.activeProject) return;
    
    try {
      const text = await file.text();
      const parsed = JSON.parse(text);
      
      if (!parsed.log || !parsed.log.entries) {
        throw new Error("Invalid HAR file format");
      }

      const harId = Math.random().toString(36).substr(2, 9);
      const currentEntries = this.activeProject.harEntries;
      
      const newEntries = parsed.log.entries.map((entry, idx) => ({
        ...entry,
        _index: currentEntries.length + idx,
        _id: `entry-${harId}-${idx}`,
        _selected: false,
        _harId: harId,
        _harName: file.name
      }));

      this.activeProject.harEntries.push(...newEntries);
      
      // Auto switch to explore if it was upload
      if (this.viewMode === 'UPLOAD') {
        this.viewMode = 'EXPLORE';
      }
    } catch (e) {
      console.error("Failed to add HAR file", e);
      alert("Failed to add HAR file: " + e.message);
    }
  },

  removeHarFile(id) {
      if (!this.activeProject) return;
      this.activeProject.harEntries = this.activeProject.harEntries.filter(e => e.id !== id);
  },

  setViewMode(mode) {
    this.viewMode = mode;
  },

  toggleChat() {
    this.isChatOpen = !this.isChatOpen;
  },

  closeProject() {
    // In real app, maybe redirect or clear state
    this.activeProject = null;
  }
});
