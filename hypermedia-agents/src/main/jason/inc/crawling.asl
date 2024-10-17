+!explore
    :  home_workspace(HomeName, HomeWorkspaceIRI) & webid(MyWebID)
    <- .print("My home workspace IRI is: ", HomeWorkspaceIRI);
       start; // starts the notification server
       +seen(HomeWorkspaceIRI, HomeName);
       makeArtifact(HomeName, "org.hyperagents.jacamo.artifacts.yggdrasil.WorkspaceThingArtifact", [HomeWorkspaceIRI], ArtId);
       focus(ArtId);
       setOperatorWebId(MyWebID)[artifact_id(ArtId)];
       .print("Created workspace artifact! Joining with WebID: ", MyWebID);
       joinHypermediaWorkspace[artifact_id(ArtId)];
       +joinedWsp(HomeWorkspaceIRI);
       ?websub(HubIRI, TopicIRI)[artifact_id(ArtId)];
       lookupArtifact(HomeName, HomeWkspId);
       registerArtifactForWebSub(TopicIRI, HomeWkspId, HubIRI);
    .

+parentHypermediaWorkspace(ParentIRI, ParentName, _) :  not seen(_, ParentName)
    <- !loadWorkspace(ParentIRI, ParentName).

+hypermediaWorkspace(WorkspaceIRI, WorkspaceName, _):  not seen(_, WorkspaceName)
    <- !loadWorkspace(WorkspaceIRI, WorkspaceName).

+!loadWorkspace(WorkspaceIRI, WorkspaceName) :  not seen(_, WorkspaceName)
    <- makeArtifact(WorkspaceName, "org.hyperagents.jacamo.artifacts.yggdrasil.WorkspaceThingArtifact", [WorkspaceIRI], ArtId);
       focus(ArtId);
       +seen(WorkspaceIRI, WorkspaceName);
    .

+hypermediaArtifact(ArtifactIRI, ArtifactName, SemanticTypes)[artifact_name(WorkspaceName),artifact_id(WorkspaceId)]
    :  .member("https://example.org/BoundedBuffer", SemanticTypes) & webid(MyWebID)
    <- .term2string(WorkspaceName, WorkspaceNameStr);
       ?seen(WorkspaceIRI, WorkspaceNameStr);
       .print("I found the buffer artifact in workspace: ", WorkspaceIRI);
       setOperatorWebId(MyWebID)[artifact_id(WorkspaceId)];
       joinHypermediaWorkspace[artifact_id(WorkspaceId)];
       +bounded_buffer_artifact(ArtifactIRI, ArtifactName);
    .