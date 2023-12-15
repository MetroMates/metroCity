//
//  Workspace.swift
//  ProjectDescriptionHelpers
//
//  Created by woojin Shin on 2023/11/21.
//

import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(name: workspaceName, projects: ["\(projectFolder)/App",
                                                          "\(projectFolder)/FirebaseSPM",
                                                          "\(projectFolder)/SPM"], additionalFiles: ["README.md"])
