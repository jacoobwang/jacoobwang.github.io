---
title: "编辑器-前端代码风格规范"
date: 2025-03-10T00:00:00+08:00
draft: false
description: "前端项目代码风格规范，包括 ESLint、Git、TypeScript 配置"
---

最近在升级一个旧的项目，早前的项目由于没有使用 ts，改起来有点痛苦以及当时没有做好的规范约束，以至于不同人贡献的代码差别很大，看着着实痛苦。

## 规范的意义

1、保证代码的一致性，从根本上提高代码整体的可读性、可维护性、可复用性：保持一致的编码风格，能让其他人在维护代码时能快速上手，即使没有什么经验的开发同学也能保障其代码的交付质量，为后期维护提供更好的支持。

2、有效降低开发和沟通的成本，提升团队整体效率：大型项目最复杂的模块往往仅占整体的一小部分，更多的是相对简单的日常开发和维护。遵循统一的技术规范，能够有效的降低多人协作工程中的沟通成本。如果没有统一规范则出现混乱的局面，留下庞大的技术债。

## 技术栈统一

- 基础：Typescript + Tsx
- 框架：React + React Dom
- Css 处理器：Sass
- UI 框架：Ant Design / DongDesign
- 状态管理：React Redux + Rematch
- 构建工具：Vite

## ESLint 规范

### 基准规则

不重复造轮子，基于 eslint:recommend 配置并改进
能够帮助发现代码错误的规则，全部开启

### ESLint 规则

- 允许非大写开头的构造函数名 ( new-cap: 0 )
- 禁止使用 var ( no-var: 2 )
- 限制 console 使用，仅允许 warn 和 error ( no-console: [1, { allow: ['warn', 'error'] }] )
- 禁用内部声明 ( no-inner-declarations: 2 )
- 强制使用 const 声明不会被修改的变量 ( prefer-const: [2, { 'destructuring': 'all' }] )
- 禁止特定语法，如 debugger、label 和 with 语句

### React 规则

- 允许组件没有 displayName
- 禁止 JSX 中的重复属性
- 禁止未定义的 JSX 元素
- 禁止直接修改 state
- 强制组件的 render 方法返回值
- 不要求 prop-types 验证
- 不要求导入 React (新版 React 不需要)
- 禁止在 componentDidUpdate 中使用 setState
- 鼓励使用无状态函数组件
- 强制执行 React Hooks 规则

### Import 规则

- 禁止未使用的模块
- import 语句后需要空行
- 禁止使用 CommonJS 模块语法 (require)，但允许条件性 require
- 禁止重复导入

### Import 排序

- 强制对 imports 和 exports 进行排序

### TypeScript 规则

- 不强制函数返回类型注解
- 允许变量在定义前使用
- 对未使用的变量发出警告
- 不强制模块边界类型
- 允许特定情况下的空函数
- 允许 this 别名
- 允许 require 语句
- 允许 @ts-comment 注释

## Git 规范

### commit日志基本规范

```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

- feat： 新增 feature
- fix: 修复 bug
- docs: 仅仅修改了文档，比如 README, CHANGELOG, CONTRIBUTE等等
- style: 仅仅修改了空格、格式缩进、逗号等等，不改变代码逻辑
- refactor: 代码重构，没有加新功能或者修复 bug
- perf: 优化相关，比如提升性能、体验
- test: 测试用例，包括单元测试、集成测试等
- chore: 改变构建流程、或者增加依赖库、工具等
- revert: 回滚到上一个版本

### 分支规范

- test 测试分支
- master 主分支
- release release 分支
- feat/xxx 特性分支
- hotfix/xxx 修复分支

### ESLint 配置示例

```yaml
extends:
  - eslint:recommended
  - plugin:react/recommended
  - plugin:@typescript-eslint/eslint-recommended
  - plugin:@typescript-eslint/recommended
  - prettier
  - plugin:import/errors
  - plugin:import/warnings
  - plugin:import/typescript

parser: '@typescript-eslint/parser'

env:
  es6: true
  node: true

plugins:
  - react
  - prettier
  - react-hooks
  - simple-import-sort
  - unused-imports
  - '@typescript-eslint'

parserOptions:
  sourceType: module
  ecmaFeatures:
    jsx: true

rules:
  prettier/prettier:
    [
      2,
      {
        singleQuote: true,
        trailingComma: 'es5',
        semi: false,
        'endOfLine': 'auto',
      },
    ]

  # eslint
  new-cap: 0
  no-var: 2
  no-console: [1, { allow: ['warn', 'error'] }]
  no-unused-vars: 0
  no-inner-declarations: 2
  camelcase: 0
  no-useless-escape: 0
  no-prototype-builtins: 0
  no-restricted-syntax:
    - 2
    - DebuggerStatement
    - LabeledStatement
    - WithStatement
  require-atomic-updates: 0
  prefer-rest-params: 0
  prefer-const: [2, { 'destructuring': 'all' }]
  prefer-spread: 0

  # react
  react/display-name: 0
  react/jsx-no-duplicate-props: 2
  react/jsx-no-undef: 2
  react/no-deprecated: 0
  react/no-direct-mutation-state: 2
  react/no-render-return-value: 2
  react/require-render-return: 2
  react/jsx-uses-react: 1
  react/jsx-uses-vars: 1
  react/prop-types: 0
  react/react-in-jsx-scope: 0
  react/no-did-update-set-state: 2
  react/no-redundant-should-component-update: 2
  react/no-typos: 2
  react/no-unused-prop-types: 2
  react/no-unused-state: 2
  react/prefer-stateless-function: [1, { ignorePureComponents: true }]
  react/void-dom-elements-no-children: 2
  react/jsx-boolean-value: 1
  react/jsx-no-bind: [2, { ignoreRefs: true, allowArrowFunctions: true }]
  react-hooks/rules-of-hooks: 2
  react-hooks/exhaustive-deps: 1
  react-perf/jsx-no-new-object-as-prop: 1
  react-perf/jsx-no-new-array-as-prop: 1

  # import
  import/no-unused-modules: 2
  import/newline-after-import: 2
  import/no-commonjs: [2, { allowConditionalRequire: true }]
  import/no-duplicates: 2

  # simple-import-sort
  simple-import-sort/imports: 2
  simple-import-sort/exports: 2

  # typescript
  '@typescript-eslint/camelcase': 0
  '@typescript-eslint/explicit-function-return-type': 0
  '@typescript-eslint/no-use-before-define': 0
  '@typescript-eslint/no-unused-vars': [1, { ignoreRestSiblings: true }]
  '@typescript-eslint/explicit-module-boundary-types': 0
  '@typescript-eslint/ban-types': 0
  '@typescript-eslint/no-empty-function':
    [1, { 'allow': ['private-constructors', 'protected-constructors'] }]
  '@typescript-eslint/no-this-alias': 0
  '@typescript-eslint/no-var-requires': 0
  '@typescript-eslint/ban-ts-comment': 0
  '@typescript-eslint/strict-boolean-expressions':
    [1, { allowNullableBoolean: true }]

overrides:
  - files:
      - '*.js'
      - '*.jsx'
    rules:
      import/no-commonjs: 0
  - files:
      - '*.ts'
      - '*.tsx'
    rules:
      import/no-unresolved: 0
      lodash/prefer-lodash-method: 0
```

### VSCode 配置

```json
{
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "search.exclude": {
  },

  "editor.formatOnSave": false,
  "editor.renderControlCharacters": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },

  "[less]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "[css]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "[yaml]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "[html]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "[json]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "vscode.json-language-features",
  },
  "[markdown]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "[mdx]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "files.associations": {
      "*.xml": "html",
      "*.svg": "html",
  },

  "prettier.ignorePath": ".eslintignore",
  "liveServer.settings.port": 5501,
  "code-runner.executorMapByGlob": {
    "*.test.*": "cd $dir && yarn test --files $fullFileName",
  },
  "typescript.tsdk": "node_modules/typescript/lib",
  "search.followSymlinks": false,
  "files.exclude": {
    "**/.git": true,
    "**/.svn": true,
    "**/.hg": true,
    "**/CVS": true,
    "**/.DS_Store": true,
    "**/tmp": true,
    "**/bower_components": true,
  },
  "files.watcherExclude": {
    "**/.git/objects/**": true,
    "**/.git/subtree-cache/**": true,
    "**/node_modules/**": true,
    "**/tmp/**": true,
    "**/bower_components/**": true,
    "**/dist/**": true
  },
  "makefile.configureOnOpen": false
}
```

### tsconfig 配置

```json
{
  "compilerOptions": {
    "typeRoots": ["./node_modules/@types", "./types"],
    "target": "es5",
    "lib": [
      "dom",
      "dom.iterable",
      "esnext"
    ],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": false,
    "noFallthroughCasesInSwitch": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "react",
    "outDir": "./dist",
    "plugins": [
      {
        "name": "typescript-plugin-css-modules"
      }
    ],
    "paths": {
      "~/*": ["./src/*"],
      "@constant/*": ["./src/constant/*"]
    }
  },
  "exclude": [
    "build",
    "node_modules"
  ],
  "include": [
    "src", "typing.d.ts"
  ]
}
```
