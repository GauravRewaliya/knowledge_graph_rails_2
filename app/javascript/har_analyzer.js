const { createApp } = Vue;
const mockUserProfile = {
  id: 12345,
  username: "john_doe",
  email: "john.doe@example.com",
  profile: {
    firstName: "John",
    lastName: "Doe",
    age: 28,
    location: {
      city: "San Francisco",
      state: "CA",
      country: "USA",
      coordinates: {
        latitude: 37.7749,
        longitude: -122.4194
      },
      coordinates_2: {
        latitude: 37.7749,
        longitude: -122.4194
      },
      coordinates_4: {
        latitude: 37.7749,
        longitude: -122.4194
      },
    }
  },
  preferences: {
    theme: "dark",
    notifications: {
      email: true,
      push: false,
      sms: true
    },
    language: "en-US"
  },
  projects: [
    {
      id: 1,
      name: "Project Alpha",
      status: "active",
      contributors: 5
    },
    {
      id: 2,
      name: "Project Beta",
      status: "completed",
      contributors: 3
    }
  ],
  tags: ["developer", "javascript", "react", "node.js"],
  isActive: true,
  lastLogin: "2025-10-01T10:30:00Z"
};

document.addEventListener("DOMContentLoaded", () => {
  const app = createApp({
    data() {
      return {
        // HAR file list (will be filled when user uploads)
        files: [],

        // all requests extracted from uploaded HARs
        requests: [],

        // filters
        filterCategory: "all",
        searchQuery: "",

        // detail view
        activeTab: "headers",
        selectedRequest: null,

        // resizable panel
        rightPanelWidth: 600,
        isResizing: false
      };
    },

    watch: {
      selectedRequest(newReq) {
        if (newReq && this.activeTab === 'response' && newReq.response.mimeType === 'application/json') {
          this.$nextTick(() => {
            this.renderJsonViewer();
          });
        }
      },
      activeTab(newTab) {
        if (newTab === 'response' && this.selectedRequest?.response.mimeType === 'application/json') {
          this.$nextTick(() => {
            this.renderJsonViewer();
          });
        }
      }
    },

    computed: {
      filteredRequests() {
        let filtered = this.requests;

        // Filter by category
        if (this.filterCategory !== "all") {
          filtered = filtered.filter(req => req.type === this.filterCategory);
        }

        // Search by URL
        if (this.searchQuery.trim() !== "") {
          filtered = filtered.filter(req =>
            req.url.toLowerCase().includes(this.searchQuery.toLowerCase())
          );
        }

        return filtered;
      }
    },

    methods: {
      addFile(fileObj) {
        // fileObj should include { name, totalRequests, totalSize, loadTime, requests }
        this.files.push({
          name: fileObj.name,
          totalRequests: fileObj.totalRequests,
          totalSize: fileObj.totalSize,
          loadTime: fileObj.loadTime
        });

        // merge requests
        this.requests = this.requests.concat(fileObj.requests);
      },

      editFileName(idx) {
        const newName = prompt("Enter new file name:", this.files[idx].name);
        if (newName) this.files[idx].name = newName;
      },

      discardFile(idx) {
        if (confirm("Remove this file?")) {
          const removedFile = this.files[idx];
          this.files.splice(idx, 1);

          // also remove its requests
          this.requests = this.requests.filter(
            req => req.fileName !== removedFile.name
          );
        }
      },

      showDetail(req) {
        this.selectedRequest = req;
      },

      deleteRequest(idx) {
        if (confirm("Delete this request?")) {
          this.requests.splice(idx, 1);
        }
      },

      renderJsonViewer() {
        const container = this.$refs.responseViewer;
        if (!container) return;

        // Clear existing content
        container.innerHTML = '';

        // Create a new json-viewer element
        const viewer = document.createElement('json-viewer');

        // Parse and set the response data
        try {
          const jsonData = typeof this.selectedRequest.response.text === 'string'
            ? JSON.parse(this.selectedRequest.response.text)
            : this.selectedRequest.response.text || this.selectedRequest.response;
          viewer.data = jsonData;
        } catch (e) {
          viewer.data = this.selectedRequest.response;
        }

        // Append the viewer to the container
        container.appendChild(viewer);
      },

      handleFileUpload(event) {
        const file = event.target.files[0];
        if (!file) return;

        const reader = new FileReader();
        reader.onload = (e) => {
          try {
            const harData = JSON.parse(e.target.result);

            const entries = harData.log.entries || [];
            const totalSize = entries.reduce((sum, entry) => sum + (entry.response?.content?.size || 0), 0);
            const totalTime = entries.reduce((sum, entry) => sum + (entry.time || 0), 0);

            const requests = entries.map(entry => ({
              fileName: file.name,
              method: entry.request.method,
              url: entry.request.url,
              status: entry.response.status,
              type: entry._resourceType || "other",
              size: entry.response?.content?.size || 0,
              time: entry.time,
              start: entry.startedDateTime,
              headers: entry.request.headers,
              payload: entry.request.postData || {},
              response: entry.response.content || {}
            }));

            this.addFile({
              name: file.name,
              totalRequests: entries.length,
              totalSize: filesize(totalSize),
              loadTime: totalTime + " ms",
              requests
            });
          } catch (err) {
            alert("Invalid HAR file: " + err.message);
          }
        };
        reader.readAsText(file);
      },

      startResize() {
        this.isResizing = true;
        document.addEventListener('mousemove', this.resize);
        document.addEventListener('mouseup', this.stopResize);
      },

      resize(event) {
        if (!this.isResizing) return;
        const newWidth = window.innerWidth - event.clientX;
        if (newWidth >= 300 && newWidth <= window.innerWidth - 300) {
          this.rightPanelWidth = newWidth;
        }
      },

      stopResize() {
        this.isResizing = false;
        document.removeEventListener('mousemove', this.resize);
        document.removeEventListener('mouseup', this.stopResize);
      },

      exportHAR() {
        // Build HAR structure
        const harData = {
          log: {
            version: "1.2",
            creator: {
              name: "HAR Analyzer",
              version: "1.0"
            },
            entries: this.requests.map(req => ({
              startedDateTime: req.start,
              time: req.time,
              request: {
                method: req.method,
                url: req.url,
                headers: req.headers,
                postData: req.payload
              },
              response: {
                status: req.status,
                content: req.response
              },
              _resourceType: req.type
            }))
          }
        };

        // Create download
        const blob = new Blob([JSON.stringify(harData, null, 2)], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `exported_${Date.now()}.har`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
      }
    }
  });

  app.mount("#app");
});
