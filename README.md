
Some refinements to reading on a screen.
----

> text in leaves.

Demo http://repo.tiye.me/tiye/leaf-reading/ .

### Development

Use Calcit 0.29.1, Node 24 and Yarn 4.12.0. `calcit.cirru` is the canonical
source; `deps.cirru` pins the compiler and published module releases.
The retired `compact.cirru` is no longer used or tracked.
Formal modules are Respo 0.16.116, UI 0.7.35, Reel 0.6.35 and js-ffi 0.2.1.

```sh
caps --strict --ci
yarn install --immutable
caps verify --toolchain
calcit --check-only --all-defs
calcit test --require-match
yarn dev
```

For source changes, run `yarn watch` in a separate terminal. `yarn build`
generates JavaScript and builds the frontend without an extra process runner.

The existing `workflow` localStorage key and saved Map format are retained.
Legacy saved drafts are decoded into typed String/Bool fields. View toggles
mount and unmount Codearea with the textarea. Autosave runs every 60 seconds.

### Deployment

`VITE_BASE_URL` selects the asset base, defaulting to `./` locally. CI uses
`https://cos-sh.tiye.me/jiyinyiyong/leaf-reading/` for production and isolated
`pr/<number>/` paths when building PRs. PR checks do not deploy.
The COS action verifies uploaded frontend files itself; no extra verification
script is needed. Configure `COS_BUCKET`, `COS_SECRET_ID`, `COS_SECRET_KEY`
and `rsync_private_key` before merging a deployment change.
The existing rsync destination `/web-assets/repo/jiyinyiyong/leaf-reading`
is unchanged. There is no backend deployment. `js-out/` and `dist/` stay ignored.

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

### License

MIT
