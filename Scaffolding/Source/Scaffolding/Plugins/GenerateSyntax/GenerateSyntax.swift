import Foundation
import PackagePlugin

@main struct CopySources: BuildToolPlugin {

  func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
    let executable = try context.tool(named: "generate‐syntax").path
    let plugInWork = context.pluginWorkDirectory

    let destination = plugInWork.appending(subpath: "Generated Syntax.swift")

    return [
      .buildCommand(
        displayName: "Generate Syntax",
        executable: executable,
        arguments: [destination],
        inputFiles: [],
        outputFiles: [destination]
      )
    ]
  }
}
