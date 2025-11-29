// customProxy.js

export async function customProxy({
  is_proxy = true,
  base_url = "http://localhost:3000/proxy",
  custom_app_key = null,

  requestFn,          // REQUIRED: function that returns { url, method, headers, body }
  beforeProcess = () => {},
  afterProcess = () => {},
  onSuccess = () => {},
  onError = () => {},
}) {
  try {
    beforeProcess();

    const req = await requestFn();

    let finalUrl = req.url;
    let finalMethod = req.method || "GET";
    let finalHeaders = req.headers || {};
    let finalBody = req.body || null;

    let response;

    if (is_proxy) {
      response = await fetch(`${base_url}?target=${encodeURIComponent(finalUrl)}`, {
        method: finalMethod,
        headers: {
          ...finalHeaders,
          ...(custom_app_key ? { "X-App-Key": custom_app_key } : {})
        },
        body: finalBody
      });
    } else {
      response = await fetch(finalUrl, {
        method: finalMethod,
        headers: finalHeaders,
        body: finalBody
      });
    }

    const rawText = await response.text();
    let parsed;

    try { parsed = JSON.parse(rawText); } 
    catch { parsed = rawText; }

    if (response.ok) {
      onSuccess(parsed, response);
    } else {
      onError(parsed, response);
    }

    afterProcess();

    return parsed;

  } catch (err) {
    onError(err);
    afterProcess();
    throw err;
  }
}
