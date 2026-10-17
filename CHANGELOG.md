---

# 📃 • CHANGELOG

- WebUI is now stable
- Applying a bootanimation is now atomic: the file is copied to a temporary file first and only replaces the current one once the copy succeeds, so a failed copy an no longer leave a corrupted bootanimation behind
- Minor fixes and general logic improvements

---

## What's Changed
* [refactor: general improvements #21](https://github.com/readonlynux/bootanimation-module/pull/21)

**Full Changelog**: https://github.com/readonlynux/bootanimation-module/compare/v1.2.2-stable...v1.3-stable

---
