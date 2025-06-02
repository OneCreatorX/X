import ipRangeCheck from "ip-range-check"

export function formatTime(ms) {
  const h = Math.floor(ms / 3600000)
  const m = Math.floor((ms % 3600000) / 60000)
  if (h > 0) return h + "h " + m + "m"
  else if (m > 0) return m + "m"
  else return Math.floor(ms / 1000) + "s"
}

export function maskIP(ip, showIP = false) {
  if (!showIP) {
    return "Hidden"
  }
  return ip
}

export function parseServiceCompletions(comp) {
  if (!comp) return {}
  if (typeof comp === "object" && !Array.isArray(comp)) return comp
  try {
    return JSON.parse(comp)
  } catch (e) {
    return {}
  }
}

export function generateRandomId(length = 16) {
  return crypto.randomBytes(length).toString("hex")
}

export function isValidSession(session, currentTime = Date.now(), timeout = 600000) {
  if (!session) return false
  return currentTime - session.created <= timeout
}

export function cleanupMap(map, maxSize = 1000, cleanupRatio = 0.4) {
  if (map.size > maxSize) {
    const entries = Array.from(map.entries())
    const toDelete = entries.slice(0, Math.floor(maxSize * cleanupRatio))
    toDelete.forEach(([key]) => map.delete(key))
  }
}

export function validateIPRange(ip, range, tolerance = 4) {
  if (!ip || !range || ip === "unknown" || range === "unknown") return false
  if (!range.includes("/")) return ip === range
  
  try {
    return ipRangeCheck(ip, range)
  } catch (e) {
    return false
  }
}
