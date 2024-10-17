package org.hyperagents.demo;

import cartago.GUARD;
import cartago.OPERATION;
import cartago.OpFeedbackParam;
import ch.unisg.ics.interactions.wot.td.schemas.ArraySchema;
import ch.unisg.ics.interactions.wot.td.schemas.IntegerSchema;
import org.hyperagents.yggdrasil.cartago.artifacts.HypermediaTDArtifact;

import java.util.LinkedList;
import java.util.Queue;

public class BoundedBuffer extends HypermediaTDArtifact {
    private final Queue<Integer> internalBuffer = new LinkedList<>();
    private int size = 0;

    public void init(final int size) {
        this.size = size;
    }

    @OPERATION
    public void enqueue(final int item) {
        this.await("isBufferNotFull");
        this.internalBuffer.add(item);
        this.log("Item (" + item + ") has been enqueued!");
    }

    @GUARD
    private boolean isBufferNotFull() {
        return this.internalBuffer.size() < this.size;
    }

    @OPERATION
    public void poll(final OpFeedbackParam<Integer> item) {
        this.await("isBufferNotEmpty");
        final var polledItem = this.internalBuffer.remove();
        this.log("Item (" + polledItem + ") has been polled!");
        item.set(polledItem);
    }

    @GUARD
    private boolean isBufferNotEmpty() {
        return !this.internalBuffer.isEmpty();
    }

    @Override
    protected void registerInteractionAffordances() {
        this.registerActionAffordance(
            "https://example.org/Enqueue",
            "enqueue",
            "enqueue",
            new ArraySchema.Builder()
                           .addItem(new IntegerSchema.Builder().build())
                           .build()
        );
        this.registerActionAffordance(
            "https://example.org/Poll",
            "poll",
            "poll",
            null,
            new ArraySchema.Builder()
                .addItem(new IntegerSchema.Builder().build())
                .build()
        );
    }
}
