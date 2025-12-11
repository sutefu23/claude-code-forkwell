---
marp: true
theme: kouen
class: lead
paginate: true
backgroundColor: white
header: "**Claude CodeによるAI駆動開発入門と実践**"
---
<script src="https://cdn.tailwindcss.com/"></script>
<script>tailwind.config = { corePlugins: { preflight: false } }</script>

<style scoped>
section{
  text-align:center;
}
</style>


# カスタム機能群の特徴と使用例まとめ


---

## **どんなものがあるか**

- カスタムスラッシュコマンド
- サブエージェント
- Hooks
- MCPサーバー
- Agent Skills

結論：
基本的に手順があるものはSkills、専門性が高いものはサブエージェント、MCPにしかない機能はMCPサーバー、確定的な動作をさせたい時はHooks、特定の指示のまとまりを任意のタイミングで使いたい時はスラッシュコマンド

---

## **Custom Slash Commands**

### 概要

プロンプトを保存し、スラッシュコマンドとして呼び出せる機能。
予備だす形なので、コンテキストを占有しない。

### 設定方法
`~/.claude/commands`配下にMDファイルを保存することで利用可能。
一度再起動が必要。

### 使用例

一塊のプロンプトとして使用できるもの。
例：コードレビュー、テストコード生成、ドキュメント生成など

---
<style scoped>
section {
  font-size: 27px;
}
</style>

## **サブエージェント**

### 概要

メインのClaudeセッションとは別に、独立したClaudeセッションを作成できる機能。
メインエージェントからコンテキストは切り離されているため、精度を高める事が期待できる。

### 設定方法
`/agent`コマンドで新しいエージェントを作成。もしくは`.claude/agents`配下にMDファイルを保存することで利用可能。名称もしくは@で呼び出すか、必要な時に自動で呼び出される。コンテキストを占有。

### 使用例

特定モジュールの開発、テスト、デバッグ、エラー解決など。特定の専門家(フロントエンド・バックエンド・DB設計など)として振る舞わせる。

---
<style scoped>
section {
  font-size: 28px;
}
</style>

## **Hooks**

### 概要

特定のトリガーに基づいて自動的に実行されるカスタムスクリプトやコマンドを定義できる機能。エラーも吐かずデバッグしにくいのが難点。コンテキストを占有しない。

### 設定方法

`~/settings.(local).json`にイベント（発火タイミング）を記載。
これまで特定のコマンドだけだったが、最近StopとSubagentStopのみプロンプトも指定できるようになった。

### 使用例
フォーマッターやリンターを実行させる、実行ログを残す、Stopイベントを使って作業が完了したら音を鳴らす。通知を送る。

---
<style scoped>
section {
  display: flex;
  flex-direction: column;
  flex-wrap: nowrap;
  justify-content: center;
  text-align: center;
  font-size: 22px;
}
</style>

| イベント | 内容 | macher |
|--------|-------------|-----|
| PreToolUse |  Tool実行前にHookを実行 | `Task`, `Bash`, など|
| PostToolUse | Tool実行後にHookを実行 | 同上 |
| Notification | ClaudeがBash実行の許可やアイドル時に通知を送信した時 | なし |
| UserPromptSubmit | ユーザーがプロンプトを入力した時 | なし |
| Stop | メインエージェントが応答を完了した時（ただしユーザーが強制的に中断した時は入りません。） | なし |
| SubagentStop | Claude Codeサブエージェントが応答を完了した時 | なし |
| PreCompact | コンパクトが呼び出された時 | `manual`: /compact呼び出し時、`auto`: 自動コンパクト時 |
| SessionEnd | セッションが終了した時に実行。reasonフィールドで終了理由を示す事が可能 | なし |
| SessionStart | Claude Codeが新しいセッションを開始または再開した時 | `startup`: 初回起動等 |

---

## **まとめ**

| 機能 | コンテキスト占有 | 動作タイミング | 発火 | 概略 |
|------|-----------------|--------------|----|---------|
| **スラッシュコマンド** | 小 | 明示的なコマンド実行時 | 確定的 | プロンプトをまとめておける |
| **サブエージェント** | あり | 明示的な呼び出し or 自動 | 確定的　or 確率的 | 特定の専門家を作れる |
| **Hooks** | なし | イベント時 | 確定的 | コマンドを実行できる（一部プロンプト） |
| **MCPサーバー** | やや大 | 常時接続・必要時にツール呼び出し　| 確定的 | 様々な機能と繋げられる |
| **Agent Skills** | 極小 | 自然言語で自動検出 | 確定的だがやや確率的 | 手順を与えられる  |


---

## 公式による違いの説明

Skills explained: How Skills compares to prompts, Projects, MCP, and subagents
https://www.claude.com/blog/skills-explained

