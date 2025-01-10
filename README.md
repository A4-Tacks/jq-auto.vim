This plugin can easily and quickly use [jq] in JSON files,
and respond to real-time modifications.

[jq]: https://github.com/jqlang/jq

# Install
```vimscript
Plug 'A4-Tacks/jq-auto.vim'
```

# Variables
- **g:jqauto_jqwinsize**: Expanded jq window lines.
- **g:jqauto_timeout**: The maximum running time of the jq process.

# Commands
- **JQOpen**: (json file only) Open real-time jq buffer,
  input lines from `1, .`, output to `.+1`.

**Examples**:
```
JQOpen --indent 4
```
