  // --- Icons Component ---
  const Icon = {
    props: ['name', 'size', 'color'],
    template: `
      <svg 
        xmlns="http://www.w3.org/2000/svg" 
        :width="size || 24" 
        :height="size || 24" 
        viewBox="0 0 24 24" 
        fill="none" 
        :stroke="color || 'currentColor'" 
        stroke-width="2" 
        stroke-linecap="round" 
        stroke-linejoin="round"
      >
        <path v-if="name === 'upload'" d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M17 8l-5-5-5 5M12 3v12"/>
        <path v-if="name === 'bar-chart-2'" d="M18 20V10M12 20V4M6 20v-6"/>
        <circle v-if="name === 'globe'" cx="12" cy="12" r="10"></circle>
        <path v-if="name === 'globe'" d="M2 12h20M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>
        <path v-if="name === 'database'" d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/><path v-if="name === 'database'" d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/><ellipse v-if="name === 'database'" cx="12" cy="5" rx="9" ry="3"/>
        <path v-if="name === 'share-2'" d="M18 5a3 3 0 1 0-3 3c-.1 0-.2 0-.3-.1l-5.8 3.4a3 3 0 1 0 0 4.4l5.8 3.4a3 3 0 1 0 3-3"/>
        <path v-if="name === 'flask-conical'" d="M10 2v7.527a2 2 0 0 1-.211.896L4.72 20.55a1 1 0 0 0 .9 1.45h12.76a1 1 0 0 0 .9-1.45l-5.069-10.127A2 2 0 0 1 14 9.527V2"/><line v-if="name === 'flask-conical'" x1="8.5" y1="2" x2="15.5" y2="2"/><path v-if="name === 'flask-conical'" d="M8.5 14h7"/>
        <path v-if="name === 'settings'" d="M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.1a2 2 0 0 1-1-1.74v-.51a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z"/><circle v-if="name === 'settings'" cx="12" cy="12" r="3"/>
        <path v-if="name === 'message-square'" d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
        <path v-if="name === 'arrow-left'" d="M19 12H5M12 19l-7-7 7-7"/>
        <path v-if="name === 'trash'" d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
        <line v-if="name === 'x'" x1="18" y1="6" x2="6" y2="18"></line><line v-if="name === 'x'" x1="6" y1="6" x2="18" y2="18"></line>
        <path v-if="name === 'search'" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
        <path v-if="name === 'file-plus'" d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline v-if="name === 'file-plus'" points="14 2 14 8 20 8"/><line v-if="name === 'file-plus'" x1="12" y1="18" x2="12" y2="12"/><line v-if="name === 'file-plus'" x1="9" y1="15" x2="15" y2="15"/>
        <path v-if="name === 'check-square'" d="M9 11l3 3L22 4"/><path v-if="name === 'check-square'" d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/>
        <rect v-if="name === 'square'" x="3" y="3" width="18" height="18" rx="2" ry="2"/>
        <path v-if="name === 'layers'" d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
        <circle v-if="name === 'clock'" cx="12" cy="12" r="10"/><polyline v-if="name === 'clock'" points="12 6 12 12 16 14"/>
        <path v-if="name === 'arrow-right'" d="M5 12h14M12 5l7 7-7 7"/>
      </svg>
    `
  };
