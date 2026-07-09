const request = require('supertest');
const { createApp, sum } = require('../src/app');

describe('sum()', () => {
  it('adds a list of numbers', () => {
    expect(sum([1, 2, 3, 4])).toBe(10);
  });

  it('returns 0 for an empty list', () => {
    expect(sum([])).toBe(0);
  });
});

describe('HTTP routes', () => {
  const app = createApp();

  it('GET /healthz returns ok', async () => {
    const res = await request(app).get('/healthz');
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ status: 'ok' });
  });

  it('GET / returns service metadata', async () => {
    const res = await request(app).get('/');
    expect(res.status).toBe(200);
    expect(res.body.service).toBe('platform-core-service');
  });

  it('POST /sum adds the provided values', async () => {
    const res = await request(app).post('/sum').send({ values: [10, 20, 12] });
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ sum: 42 });
  });

  it('POST /sum rejects invalid input', async () => {
    const res = await request(app).post('/sum').send({ values: 'nope' });
    expect(res.status).toBe(400);
  });
});
