!explore.

+hypermediaArtifact(ArtifactIRI, ArtifactName, SemanticTypes)[artifact_name(WorkspaceName),artifact_id(WorkspaceId)]
    : .member("https://example.org/Sink", SemanticTypes) & sink_artifact(ArtifactIRI, ArtifactName, ArtId)
    <- .print("Re-discovered sink artifact").

+hypermediaArtifact(ArtifactIRI, ArtifactName, SemanticTypes)[artifact_name(WorkspaceName),artifact_id(WorkspaceId)]
    :  .member("https://example.org/Sink", SemanticTypes) & webid(MyWebID)
    <- .print("Creating sink artifact...");
       makeArtifact(ArtifactName, "org.hyperagents.jacamo.artifacts.wot.ThingArtifact", [ArtifactIRI], ArtId);
       setOperatorWebId(MyWebID)[artifact_id(ArtId)];
       +sink_artifact(ArtifactIRI, ArtifactName, ArtId);
       .print("Sink artifact IRI: ", ArtifactIRI);
    .

+bounded_buffer_artifact(ArtifactIRI, ArtifactName)
    :  webid(MyWebID) & sink_artifact(_, _, SinkArtId)
    <- makeArtifact(ArtifactName, "org.hyperagents.jacamo.artifacts.wot.ThingArtifact", [ArtifactIRI], BufferArtId);
       setOperatorWebId(MyWebID)[artifact_id(BufferArtId)];
       .print("Ready to start consumption!");
       !loop(SinkArtId, BufferArtId);
    .

+!loop(SinkArtId, BufferArtId) : true <-
    invokeActionWithIntegerOutput("https://example.org/Poll", Item)[artifact_id(BufferArtId)];
    .print("Item (", Item, ") has been polled");
    invokeAction("https://example.org/Consume", [[Item]])[artifact_id(SinkArtId)];
    .print("Item (", Item, ") has been consumed");
    !loop(SinkArtId, BufferArtId).

{ include("inc/crawling.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }