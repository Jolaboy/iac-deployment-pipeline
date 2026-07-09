const { createApp } = require('./app');

const port = process.env.PORT || 3000;

createApp().listen(port, () => {
  // eslint-disable-next-line no-console
  console.log(`platform-core-service listening on port ${port}`);
});
