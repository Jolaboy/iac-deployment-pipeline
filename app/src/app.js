const express = require('express');

/**
 * Build the Express application.
 *
 * Split from server.js so tests can import the app without opening a port.
 */
function createApp() {
  const app = express();
  app.use(express.json());

  app.get('/healthz', (req, res) => {
    res.status(200).json({ status: 'ok' });
  });

  app.get('/', (req, res) => {
    res.status(200).json({ service: 'platform-core-service', version: '1.0.0' });
  });

  app.post('/sum', (req, res) => {
    const { values } = req.body || {};
    if (!Array.isArray(values) || values.some((v) => typeof v !== 'number')) {
      return res.status(400).json({ error: 'values must be an array of numbers' });
    }
    res.status(200).json({ sum: sum(values) });
  });

  return app;
}

/** Add a list of numbers. */
function sum(values) {
  return values.reduce((total, value) => total + value, 0);
}

module.exports = { createApp, sum };
