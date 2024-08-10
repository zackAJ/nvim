 codeActionProvider = {
    codeActionKinds = { "refactor.class.simplify", "quickfix.import_class", "quickfix.override_method", "quickfix.promote_constructor", "quickfix.promote_constructor_public", "quickfix.complete_constructor", "quickfix.complete_constructor_public", "quickfix.add_missing_class_generic", "quickfix.create_class", "quickfix.create_unresolable_class", "quickfix.correct_variable_name", "quickfix.add_missing_properties", "quickfix.implement_contracts", "quickfix.fix_namespace_class_name", "quickfix.add_missing_docblocks_return", "quickfix.add_missing_params", "quickfix.add_missing_return_types", "quickfix.remove_unused_imports", "quickfix.generate_member", "refactor.extract.method", "refactor.extract.constant", "quickfix.generate_accessors", "quickfix.generate_mutators", "refactor.extract.expression", "quickfix.fill.object", "quickfix.fill.matchArms", "refactor", "quickfix.generate_decorator" }
  },
  completionProvider = {
    resolveProvider = true,
    triggerCharacters = { ":", ">", "$", "[", "@", "(", "'", '"', "\\" }
  },
  definitionProvider = true,
  documentHighlightProvider = true,
  documentSymbolProvider = false,
  executeCommandProvider = {
    commands = { "name_import", "transform", "create_class", "generate_member", "extract_method", "replace_qualifier_with_import", "extract_constant", "generate_accessors", "generate_mutators", "import_all_unresolved_names", "extract_expression", "generate_decorator", "override_method" }
  },
  hoverProvider = true,
  implementationProvider = true,
  referencesProvider = true,
  renameProvider = {
    prepareProvider = true
  },
  selectionRangeProvider = true,
  signatureHelpProvider = {
    triggerCharacters = { "(", ",", "@" }
  },
  textDocumentSync = {
    change = 1,
    openClose = true,
    save = {
      includeText = false
    },
    willSave = false,
    willSaveWaitUntil = false
  },
  typeDefinitionProvider = true,
  workspace = {
    fileOperations = {
      willRename = {
        filters = { {
            pattern = {
              glob = "**/*.php"
            }
          } }
      }
    }
  },
  workspaceSymbolProvider = true
