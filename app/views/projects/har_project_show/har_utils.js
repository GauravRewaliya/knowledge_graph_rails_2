  const HarUtils = {
    generateCurlCommand: (request) => {
      const parts = [];
      
      // Basic command and URL
      // Escape single quotes in URL just in case
      const url = request.url.replace(/'/g, "'\\''");
      parts.push(`curl '${url}'`);
      
      // Method
      parts.push(`-X '${request.method}'`);
      
      // Headers
      if (request.headers) {
          request.headers.forEach((header) => {
              // Skip pseudo-headers
              if (header.name.startsWith(':')) return;
              
              // Skip content-length as it's auto-calculated by curl if body exists.
              if (header.name.toLowerCase() === 'content-length') return;
  
              // Escape single quotes in header values
              const value = header.value.replace(/'/g, "'\\''");
              parts.push(`-H '${header.name}: ${value}'`);
          });
      }
  
      // Body
      if (request.postData && request.postData.text) {
          // Escape single quotes in the body
          const body = request.postData.text.replace(/'/g, "'\\''");
          parts.push(`--data-raw '${body}'`);
      }
  
      // Compression handling
      parts.push('--compressed');
      
      // Join with line continuation and indentation
      return parts.join(' \\\n  ');
    }
  };
