---
paths:
  # init-repo rewrites this to the Qt editor's dir
  - "editor/**/*.{cpp,cc,cxx,h,hh,hpp,hxx}"
---
# Qt

Both this file and `cpp.md` apply to this code. **Where they conflict, this file wins.**

- **Overrides `cpp.md`'s "no raw `new`" bullet:** `new QWidget(parent)` — any QObject created with a parent, or handed to a layout, scene or model that takes ownership — is correct; the parent's object tree deletes it. Don't wrap parented QObjects in smart pointers and don't `delete` them. A parentless QObject still needs an owner (`std::unique_ptr`, or a parent assigned right away).
- Delete live QObjects with `deleteLater()`, never with `delete` from inside their own slots or event handlers.
- New-style `connect` with member-function pointers (or a lambda with a context object), not `SIGNAL()`/`SLOT()` strings.
- Widgets live on the GUI thread; move slow work to `QThread`/`QtConcurrent` and report back through signals.
- Qt types (`QString`, `QList`, …) at Qt API boundaries; plain C++/std in the document model and anything shared with the code generator.
- Generated files (`moc_*.cpp`, `ui_*.h`, `qrc_*.cpp`, `*_autogen/`) are never edited or read — change the header, `.ui` or `.qrc` and rebuild.
