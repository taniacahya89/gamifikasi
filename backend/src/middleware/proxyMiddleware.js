const trustedProxies = [
  '127.0.0.1', // Localhost
  'localhost', // Localhost
  '::1', // IPv6 localhost
  '0.0.0.0', // All IPv4 addresses
  '192.168.1.0/24', // Local network (sesuaikan dengan jaringan Anda)
  '10.0.0.0/8', // Private network
  '172.16.0.0/12', // Private network
  'fc00::/7' // IPv6 private network
];

const isTrustedProxy = (ip) => {
  return trustedProxies.some((proxy) => {
    if (proxy.includes('/')) {
      // Handle CIDR notation
      const [base, mask] = proxy.split('/');
      const baseInt = ipToNumber(base);
      const proxyInt = ipToNumber(ip);
      const maskInt = parseInt(mask);
      return (baseInt >> (32 - maskInt)) === (proxyInt >> (32 - maskInt));
    }
    return proxy === ip;
  });
};

const ipToNumber = (ip) => {
  return ip.split('.').reduce((acc, octet) => (acc << 8) + parseInt(octet), 0);
};

module.exports = (req, res, next) => {
  const clientIP = req.header('x-forwarded-for') || req.connection.remoteAddress;
  
  if (clientIP && isTrustedProxy(clientIP)) {
    req.trusted = true;
    return next();
  }
  
  // Jika bukan trusted proxy, tetap lanjutkan (opsional: bisa diblokir)
  req.trusted = false;
  next();
};