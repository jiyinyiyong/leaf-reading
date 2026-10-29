
Some refinements to reading on a screen.
----

> text in leaves.

Demo http://repo.tiye.me/tiye/leaf-reading/ .

### 使用者需要注意

当前 CLI 与 `@calcit/procs` 配对升级为已发布正式版 0.32.1，Snapshot 类型写法已用 `edit format` 迁移到 0.32 语法，使用 Node 24、Yarn 4.18.0。存档 key `workflow`、旧 Map 格式、文本内容、View 显隐及 60 秒自动保存保持不变；不清空已有草稿。本轮保留源码和原门禁，不合并、发版或部署。

此前内部 `comp-leaf` 删除从不参与样式计算、只递归传递 nil 的参数，改为 `(leaves level)`。调用此应用内部辅助组件的代码需要同步重编译；层级解析、缩进和页面布局不变。`indentation` / `dev?` 声明为真实 String / Bool，存档外层类型收紧为 `Map<Tag, Map<Dynamic,Dynamic>>`；异构状态树仍如实保留开放类型，不增加强转或预算。

### Development

Use the released Calcit/procs 0.32.1 pair, Node 24 and Yarn 4.18.0. `calcit.cirru` is the canonical
source; `deps.cirru` pins the compiler and published module releases.
The retired `compact.cirru` is no longer used or tracked.
Declared published module tags are Respo 0.17.1, UI 0.9.0, Reel 0.7.0-alpha.5 and js-ffi 0.2.9. Stable 0.30 consumers should keep their existing maintenance graph.

```sh
caps --strict --ci
yarn install --immutable
caps verify --toolchain
calcit --check-only --all-defs
calcit fix --workflow strict --verify
calcit test --require-match
yarn dev
```

For source changes, run `yarn watch` in a separate terminal. `yarn build`
generates JavaScript and builds the frontend without an extra process runner.

The existing `workflow` localStorage key and saved Map format are retained.
Legacy saved drafts are decoded into typed String/Bool fields. View toggles
mount and unmount Codearea with the textarea. Autosave runs every 60 seconds.

原三项定义内业务测试保留，没有新增测试框架或验证脚本。完整 strict 加入现有 CI；正式配对验收以 Linux CI 的精确提交为准。本地中间 0.30.0 配对已通过全定义、完整 strict、原测试和构建，并在独立回环端口用合成文本验证三级层级、View 卸载/重新挂载与刷新恢复；不冒充正式 0.30.1 的浏览器验收。

仍保留真实 UI 子节点、存档及外部事件入口的开放合同；unsafe 为 0 不等于全项目类型闭合。原 native 存档测试中 `.to-map` 的运行时分派提示单独记录，不假称没有任何 warning，也不通过 native-call 替换或额外包装掩盖它。

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
