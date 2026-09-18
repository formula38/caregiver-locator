import { request as httpRequest } from 'node:http';
import { request as httpsRequest } from 'node:https';
import type { Request, Response } from 'express';

export function proxyApi(req: Request, res: Response): void {
  const origin = process.env['API_ORIGIN'] ?? 'http://localhost:8500';
  const target = new URL(req.originalUrl, origin);
  const send = target.protocol === 'https:' ? httpsRequest : httpRequest;
  const headers = { ...req.headers, host: target.host };
  delete headers['connection'];

  const proxyReq = send(
    target,
    {
      method: req.method,
      headers
    },
    (proxyRes) => {
      res.writeHead(proxyRes.statusCode ?? 502, proxyRes.headers);
      proxyRes.pipe(res);
    }
  );

  proxyReq.on('error', () => {
    res.status(502).json({ ok: false, error: 'API origin is unreachable' });
  });
  req.pipe(proxyReq);
}
