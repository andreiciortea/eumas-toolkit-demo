# Yggdrasil Demo for EUMAS Toolkit Papers Track

This repository demonstrates the features shipped with the latest version of Yggdrasil,
part of the "HyperAgents" project,
as described in its presenting paper submitted to the EUMAS toolkit papers track.

## Prerequisites

* Java 21+
* Gradle 8.4+
* Docker 26.1.4+

## Setup

The current repository structure uses [jacamo-hypermedia](https://github.com/HyperAgents/jacamo-hypermedia) as a git submodule. So, you'll need to clone the repository recursively, along with its submodules.

### Cloning the Repository

1. Clone this repository using the following command:

```bash
git clone --recursive git@github.com:cake-lier/eumas-toolkit-demo.git
```

2. Position yourself in the project folder, for example, using a command like the following:

```bash
cd eumas-toolkit-demo
```

3. Update all the submodules with: 

```bash
git submodule update
```

At this point, you're ready for running the demo!

### Booting the environment nodes

⚠️ Since the host needs access to the contaiRunners launched for the demo, please ensure ports 8080, 8081, and 8082 are available.
If not, update the ports to open in all configuration files in the ```environment/src/main/resources/conf``` folder and also in the ```hypermedia_agents.jcm``` configuration file in the ```hypermedia-agents``` folder before building the JAR. ⚠️

1. Build the Yggdrasil framework JAR file using the command: 

```bash
./gradlew environment:shadowJar
```

2. Launch the containers containing the three hypermedia workspaces using the command:

```bash
docker compose up
```

3. Wait until the following messages appear onscreen:

```
env_production   | [vert.x-eventloop-thread-0] INFO io.vertx.core.impl.launcher.commands.VertxIsolatedDeployer - Succeeded in deploying verticle
env_shared       | [vert.x-eventloop-thread-0] INFO io.vertx.core.impl.launcher.commands.VertxIsolatedDeployer - Succeeded in deploying verticle
env_consumption  | [vert.x-eventloop-thread-0] INFO io.vertx.core.impl.launcher.commands.VertxIsolatedDeployer - Succeeded in deploying verticle
```

⚠️ Pay attention to the fact that these messages could get buried between many others, so review the logs the containers produce with care! ⚠️

Now, the agents can be booted in two ways, depending on if you're interested in seeing how agents can exploit the hypermedia properties of Yggdrasil's artifacts to their maximum or not.

### Alternative #1: Booting Simple Agents

4. Use the following command to start the JaCaMo platform containing the simple agents in a different shell from the one you used for the Docker command:

```bash
./gradlew agents:runAgents
``` 

When you see a Java Swing window appearing, the setup is complete!
You can now examine what gets printed in it to [see the system at work](#what-is-happening).

### Alternative #2: Booting Hypermedia Agents

4. Add hyperlinks across the three hypermedia workspaces by running the following script in a different shell from the one you used for the Docker command:

```bash
./scripts/add_remote_workspaces.sh
```

You can now browse the distributed hypermedia workspace from this [entrypoint](http://localhost:8082/workspaces/manufacturing#workspace).

5. Use the following command to start the JaCaMo platform containing the hypermedia agents in a different shell from the one you used for the Docker command:

```bash
./gradlew hypermedia-agents:runAgents
``` 

When you see a Java Swing window appearing, the setup is complete!
You can now examine what gets printed in it to [see the system at work](#what-is-happening).

## Clean Up

To close the window showing the output of the JaCaMo platform, press its "stop" button.
It will orderly shut down the whole agent platform without trouble.
To terminate the containers with the workspaces in them,
press CTRL+C in the shell executing the `docker compose up` command, and then,
after the containers stop, run the command `docker compose down` to delete the containers.
If you want a complete cleanup, delete the Yggdrasil image by running the command `docker image rm environment`.

## What Is Happening?

The most impressive part is not the system goal:
the system enacts a behavior simple enough to be familiar to anyone with some grasp of distributed systems.
The system contains a producer agent and a consumer agent.
They communicate through a bounded buffer, a well-known pattern implicating that the buffer has a limited capacity.
If the buffer gets filled, the producer waits until a spot is free to add another element.
If it is empty, it is the consumer's turn to wait until a new element gets added to the buffer.
The agents take a random time each time to produce or consume an element
to break some improper synchronism between the two.

The elements are integer numbers, while their source, sink, and buffer are all hypermedia artifacts.
These artifacts exist in three different workspaces, the first in the "production"
one, the second in the "consumption" one, and the last in a "shared" workspace.
Then, a general "manufacturing"
workspace contains all three as sub-workspaces in the system alternative with hypermedia agents.
The three sub-workspaces reside on three different Yggdrasil nodes,
demonstrating that the framework is suitable for deploying distributed MAS environments.

### Basic behavior

Whenever a new element gets produced,
the source artifact prints onscreen a message like the following in the Docker logs:
```
env_production   | [source] Item (2) has been produced!
```
Then, when the "alice" agent gets the element from the source, it prints the following message on the JaCaMo console:
```
[alice] Item (2) has been received
```
It implies that the agent will try to insert the item in the buffer, waiting to do so if it is full.
On a successful insertion, the buffer artifact will print on the Docker logs:
```
env_shared       | [buffer] Item (2) has been enqueued!
```
The agent will print the following line after completing the enqueuing action:
```
[alice] Item (2) has been enqueued
```
The "bob" agent waits until a new element to remove from the buffer is ready, and when it is, the agent does so.
The buffer prints the following message:
```
env_shared       | [buffer] Item (2) has been polled!
```
The "bob" agent prints this message instead:
```
[bob] Item (2) has been polled
```
Then, the "bob" agent sends the item to the sink to consume it,
and when the operation has completed, it prints the following message on the JaCaMo console:
```
[bob] Item (2) has been sent
```
The sink artifact will print this message instead on a successful consumption:
```
env_consumption  | [sink] Item (2) has been consumed!
```
### Crawling

If the system with the plain agents gets started,
the agents join the remote workspaces they already have hardcoded in them.
They know these workspaces already contain the needed artifacts and the names and interfaces of such artifacts.
On the other hand, this is not the case when booting up hypermedia agents.

### Hypermedia Artifacts

TODO

## Final remarks

TODO