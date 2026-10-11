
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/ |reel.calcit/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'Leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Leaf (:line 'String)
            :branch $ :: 'List 'app.comp.container/Leaf
          :examples $ []
          :schema $ :: 'EnumDef
        'codearea-lifecycle! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn codearea-lifecycle! (mount?) (raise "|codearea requires the browser JavaScript target")
          :examples $ []
          :ffi $ {} (:target :browser)
            :js $ {}
              :inline "|(mount) => { const element = document.querySelector(\".draft\"); if (mount) { codearea.codearea(element); } else { codearea.teardownCodearea(element); } }"
              :modules $ {} $ :codearea |@mvc-works/codearea
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Bool
            :features $ #{} :js-ffi
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel)
            let
                store $ :store reel
                states $ :states store
                cursor $ either (:cursor states) ([])
                state $ either (:data states)
                  {} (:draft |) (:hide-input? false)
              [] (effect-text)
                div
                  {} $ :style $ merge ui/global ui/fullscreen ui/row
                  div
                    {} $ :style ui/expand
                    comp-leaf
                      parse-leaves $ .map
                        .split-lines $ :draft state
                        fn (x) (.!trimRight x)
                      , nil 0
                  =< 8 nil
                  if
                    not $ :hide-input? state
                    textarea $ {}
                      :value $ :draft state
                      :class-name |draft
                      :placeholder |Content
                      :style $ merge ui/expand ui/textarea $ {} (:font-family ui/font-code)
                      :on-input $ fn (e d!)
                        d! cursor $ assoc state :draft $ :value e
                  div ({})
                    a $ {}
                      :style $ merge ui/link $ {} (:position :absolute) (:right 8) (:bottom 8)
                      :inner-text |View
                      :on-click $ fn (e d!)
                        d! cursor $ update state :hide-input? not
                  when dev? $ comp-reel (>> states :reel) reel $ {}
          :examples $ []
        'comp-leaf $ %{} 'CodeEntry
          :doc "|递归 Leaf 输入保持具体类型。map-indexed 回调返回值只在 Respo 开放子节点边界使用 Dynamic，因为正式 div API 接收原始 Element/Component，不接受 RenderNode 枚举；不扩大 Leaf 的业务类型。"
          :code $ quote $ defcomp comp-leaf (leaves style level)
            div
              {} $ :style $ merge
                {}
                  :border $ str "|1px solid " $ hsl 170 80 98 0.3
                  :border-radius "|0 12px 0 24px"
                  :padding "|4px 8px 12px 8px"
                  :background-color "|rgb(102,102,102)"
                  :color :white
                if (> level 0)
                  {} (:margin-left 8) (:margin-bottom 16)
                  .empty $ {} (:margin-left 8) (:margin-bottom 16)
              , & $ -> leaves $ map-indexed
                fn (idx line)
                  hint-fn $ {}
                    :args $ [] 'Number 'app.comp.container/Leaf
                    :return 'Dynamic
                  match line
                    (:branch children)
                      comp-leaf children style $ inc level
                    (:line text)
                      div
                        {} (:class-name |leaf-line) (:tab-index 0)
                          :style $ {} (:padding-left 6) (:margin-left 2)
                        if (.blank? text)
                          div
                            {} $ :style $ {}
                              :color $ hsl 0 0 100 0.1
                              :user-select :none
                            <> |_
                          <> text
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] (:: 'List 'app.comp.container/Leaf) 'Nil 'Number
        'effect-text $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defeffect effect-text () (action el a)
            match (decode-map-as action 'Tag)
              :mount $ codearea-lifecycle! true
              :unmount $ codearea-lifecycle! false
              _ &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Effect)
            :args $ []
        'indentation $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def indentation "|  "
          :examples $ []
        'pack-buffer $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn pack-buffer (acc buffer)
            if (empty? buffer) acc $ .append acc $ Leaf :branch (parse-leaves buffer)
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] (:: 'List 'app.comp.container/Leaf) (:: 'List 'String)
            :return $ :: 'List 'app.comp.container/Leaf
        'parse-leaves $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn parse-leaves (lines0)
            apply-args
                []
                []
                , false false lines0
              fn (acc buffer indented? gap? lines)
                hint-fn $ {}
                  :args $ [] (:: 'List 'app.comp.container/Leaf) (:: 'List 'String) 'Bool 'Bool $ :: 'List 'String
                  :return $ :: 'List 'app.comp.container/Leaf
                if (empty? lines) (pack-buffer acc buffer)
                  let
                      l0 $ .unwrap $ first lines
                    if (.blank? l0)
                      if indented?
                        recur acc (conj buffer l0) true false $ rest lines
                        recur acc buffer false true $ rest lines
                      if indented?
                        if (.starts-with? l0 indentation)
                          recur acc
                            conj buffer $ .strip-prefix l0 indentation
                            , true false $ rest lines
                          recur
                            conj (pack-buffer acc buffer) (Leaf :line l0)
                            .empty buffer
                            , false false $ rest lines
                        if (.starts-with? l0 indentation)
                          recur acc
                            conj buffer $ .strip-prefix l0 indentation
                            , true false $ rest lines
                          recur
                            conj
                              if gap?
                                conj acc $ Leaf :line &newline
                                , acc
                              Leaf :line l0
                            .empty buffer
                            , false false $ rest lines
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] $ :: 'List 'String
            :return $ :: 'List 'app.comp.container/Leaf
          :tests $ [] $ %{} 'TestEntry (:name |legacy-layout)
            :code $ quote $ do
              assert= ([])
                parse-leaves $ []
              assert=
                [] (Leaf :line |one) (Leaf :line |two)
                parse-leaves $ [] |one |two
              assert=
                [] (Leaf :line |one) (Leaf :line &newline) (Leaf :line |two)
                parse-leaves $ [] |one | |two
              assert=
                [] (Leaf :line |one)
                  Leaf :branch $ [] (Leaf :line |two)
                    Leaf :branch $ [] $ Leaf :line |three
                  Leaf :line |four
                parse-leaves $ [] |one "|  two" "|    three" | |four
              , &unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp defeffect <> >> div button textarea span input a
            respo.comp.space :refer $ =<
            reel.comp.reel :refer $ comp-reel
            app.config :refer $ dev?
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'Site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Site (:storage-key 'String)
          :examples $ []
          :schema $ :: 'StructDef
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $ .unwrap-or (get-env |mode) |release
          :examples $ []
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site (Site :storage-key |workflow)
          :examples $ []
          :schema $ :: 'app.config/Site
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *reel
            -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
          :examples $ []
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op op-data)
            when
              and config/dev? $ not= op :states
              println |Dispatch: op
            reset! *reel $ reel-updater updater @*reel op op-data
          :examples $ []
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! () (load-console-formatter!)
            println "|Running mode:" $ if config/dev? |dev |release
            render-app!
            add-watch *reel :changes $ fn (reel prev) (render-app!)
            listen-devtools! |k dispatch!
            .!addEventListener js/window |beforeunload $ fn (event) (persist-storage!)
            repeat! 60 persist-storage!
            let
                raw $ .!getItem js/localStorage $ :storage-key config/site
              when (some? raw)
                dispatch! :hydrate-storage $ parse-cirru-edn raw
            println "|App started."
          :examples $ []
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target (query-mount-target)
          :examples $ []
          :schema $ :: 'JsNullish 'respo.dom/DomElement
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            .set-item! (host/window-local-storage) (:storage-key config/site)
              format-cirru-edn $ .unwrap $ get @*reel :store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'query-mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn query-mount-target ()
            let
                document $ js-cast js/document 'respo.dom/DomDocument
              document .query-selector |.app
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ []
            :features $ #{} :js-ffi
            :return $ :: 'JsNullish 'respo.dom/DomElement
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! () (remove-watch *reel :changes) (clear-cache!)
            add-watch *reel :changes $ fn (reel prev) (render-app!)
            reset! *reel $ refresh-reel @*reel schema/store updater
          :examples $ []
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render! mount-target (comp-container @*reel) dispatch!
          :examples $ []
        'repeat! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn repeat! (duration cb)
            host/set-interval! cb $ * 1000 duration
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Number $ :: 'Fn
              {} (:return 'Unit)
                :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render! clear-cache!
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :as schema
            reel.util :refer $ listen-devtools!
            reel.core :refer $ reel-updater refresh-reel
            reel.schema :as reel-schema
            app.config :as config
            js-ffi.browser :as host
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'Draft $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Draft (:draft 'String) (:hide-input? 'Bool)
          :examples $ []
          :schema $ :: 'StructDef
        'Op $ %{} 'CodeEntry
          :doc "|States is the heterogeneous Respo/Reel UI-state protocol, not an untyped business operation. The reducer validates the root Draft through decode-store; hydration accepts only decoded Store."
          :code $ quote $ defenum Op
            :states (:: 'List 'Dynamic) 'Dynamic
            :hydrate-storage 'app.schema/Store
          :examples $ []
          :schema $ :: 'EnumDef
        'Store $ %{} 'CodeEntry
          :doc "|The shared Respo/Reel UI state tree has heterogeneous cursor keys and values. Keep that protocol map open while decoding the application's Draft fields concretely."
          :code $ quote $ defstruct Store
            :states $ :: 'Map 'Dynamic 'Dynamic
          :examples $ []
          :schema $ :: 'StructDef
        'decode-draft $ %{} 'CodeEntry
          :doc "|Validate legacy saved draft maps and current Draft fields at the open UI-state boundary; only missing local state defaults. Business draft and visibility remain concrete."
          :code $ quote $ defn decode-draft (raw)
            if (nil? raw) default-draft $ decode-map-as
              if (struct? raw) (.to-map raw) raw
              , 'app.schema/Draft
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Draft)
            :args $ [] 'Dynamic
        'decode-store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decode-store (raw)
            let
                base $ decode-map-as
                  if (struct? raw) (.to-map raw) raw
                  , 'app.schema/Store
                states $ :states base
              struct-with base $ :states $ match (get states :data)
                (:none) states
                (:some draft)
                  assoc states :data $ decode-draft draft
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'Dynamic
          :tests $ [] $ %{} 'TestEntry (:name |legacy-draft-preservation)
            :code $ quote $ let
                raw $ {} $ :states
                  {}
                    :cursor $ []
                    :data $ {} (:draft "|one\n  two") (:hide-input? true)
                    :reel $ {} $ :data 2
                restored $ decode-store raw
                draft $ decode-draft $ .unwrap
                  get (:states restored) :data
              assert= "|one\n  two" $ :draft draft
              assert= true $ :hide-input? draft
              assert=
                {} $ :data 2
                .unwrap $ get (:states restored) :reel
              assert= restored $ decode-store restored
              assert= default-draft $ decode-draft nil
              , &unit
        'default-draft $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def default-draft (Draft :draft | :hide-input? false)
          :examples $ []
          :schema $ :: 'app.schema/Draft
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            Store :states $ {} $ :cursor ([])
          :examples $ []
          :schema $ :: 'app.schema/Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-id op-time)
            match op
              (:states cursor state)
                schema/decode-store $ struct-with store $ :states
                  decode-map-as
                    update-state-tree (:states store) cursor state
                    :: 'Map 'Dynamic 'Dynamic
              (:hydrate-storage saved) saved
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'app.schema/Store 'app.schema/Op 'String 'Number
          :tests $ [] $ %{} 'TestEntry (:name |root-and-reel-state)
            :code $ quote $ let
                edited $ updater schema/store
                  schema/Op :states ([]) (schema/Draft :draft |hello :hide-input? false)
                  , |op-1 0
                debugged $ updater edited
                  schema/Op :states ([] :reel 1)
                    {} $ :expanded? true
                  , |op-2 1
              assert= |hello $ :draft $ schema/decode-draft
                .unwrap $ get (:states debugged) :data
              assert= debugged $ updater schema/store (schema/Op :hydrate-storage debugged) |op-3 2
              , &unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require (app.schema :as schema)
            respo.cursor :refer $ update-state-tree
