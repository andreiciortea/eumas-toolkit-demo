!explore.

+hypermediaArtifact(ArtifactIRI, ArtifactName, SemanticTypes)[artifact_name(WorkspaceName),artifact_id(WorkspaceId)]
    : .member("https://example.org/Source", SemanticTypes) & source_artifact(_,_,_)
    <- .print("Re-discovered source artifact").

+hypermediaArtifact(ArtifactIRI, ArtifactName, SemanticTypes)[artifact_name(WorkspaceName),artifact_id(WorkspaceId)]
    :  .member("https://example.org/Source", SemanticTypes) & webid(MyWebID)
    <- .print("Creating source artifact...");
       makeArtifact(ArtifactName, "org.hyperagents.jacamo.artifacts.wot.ThingArtifact", [ArtifactIRI], ArtId);
       setOperatorWebId(MyWebID)[artifact_id(ArtId)];
       +source_artifact(ArtifactIRI, ArtifactName, ArtId);
    .

+bounded_buffer_artifact(ArtifactIRI, ArtifactName)
    :  webid(MyWebID) & source_artifact(_, _, SourceArtId)
    <- makeArtifact(ArtifactName, "org.hyperagents.jacamo.artifacts.wot.ThingArtifact", [ArtifactIRI], BufferArtId);
       setOperatorWebId(MyWebID)[artifact_id(BufferArtId)];
       .print("Ready to start production!");
       !loop(SourceArtId, BufferArtId);
    .

+!loop(SourceArtId, BufferArtId) : true <-
    invokeActionWithIntegerOutput("https://example.org/Produce", Item)[artifact_id(SourceArtId)];
    .print("Item (", Item, ") has been received");
    invokeAction("https://example.org/Enqueue", [[Item]])[artifact_id(BufferArtId)];
    .print("Item (", Item, ") has been enqueued");
    !loop(SourceArtId, BufferArtId).

{ include("inc/crawling.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }