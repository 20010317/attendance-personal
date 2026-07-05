const CACHE_NAME = 'attendance-cache-v2'; // ← バージョンを上げて古いキャッシュと区別する
const urlsToCache = ['./index.html', './manifest.json'];

self.addEventListener('install', event => {
  self.skipWaiting(); // 新しいService Workerをすぐ有効化する
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(urlsToCache))
  );
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(
        keys.map(key => {
          if (key !== CACHE_NAME) {
            return caches.delete(key); // 古いバージョンのキャッシュを削除
          }
        })
      )
    ).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    fetch(event.request).catch(() => caches.match(event.request)) // ネットワーク優先、失敗時のみキャッシュ
  );
});
