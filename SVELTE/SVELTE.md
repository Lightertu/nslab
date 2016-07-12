# SVELTE: Real-time intrusion detection in the Internet of Things

## Introduction 
* **6LoWPAN** (Low Power Wireless Personal Area Network) is design 
  to connect
    - It uses 802.15.4 as link and physical layer protocol
  resource constrained devices

* 6LoWPAN Border Router (**6BR**) is an edge node that connects 6LoWPAN
  network with the Internet

* Since 6LoWPAN networks are directly connected to the internet, the 
  global access makes the things vulnerable.

* Message Security has been investigated such as:
    - DTLS
    - IPsec
    - IEEE 802.15.4 linker-layer security

* This papers uses **IPv6 Routing protocol for Low Power and Lossy 
  netowrks** (RPL) which contains two components:
    - 6LoWPAN Mapper (6Mapper)
        - It reconstructs RPL's routing state (a directed acyclic graph)
    - Intrusion Detection Modules
    
* IDS placement
    - processing intensive SVELTE modules are placed in 6BR
    - Light weight modules are placed in constrained nodes

* A mini-firewall is used
## Background
* UDP (Connectionless User Datagram Protocol) is mostly used in 6LoWPAN.
* CoAP (Constrained Application Protocol) is being standardized

### RPL
* It is a IoT routing protocol for **IP-Connected** IoT.
* It create a Destination-Oriented Directed Acyclic Graph **(DODAG)**
* It support different modes of operation:
    - Uni-directional traffic to a DODAG root
    - Bi-directional traffic between nodes to root
* In-network routing tables are required to separate packets heading
  upwards and the packets heading down wards in the network. (in 
  contiki)

### Security in the IoT
* **IPSec** in transport mode provides end-to-end security between to hosts
  in IoT.
    - Ensures application data confidentiality, optionally data integrity
      and authentication
    - Mandatory to implement in 6LoWPAN and IPv6.

* **AH** protocol ensures the integrity of while IPv6 datagram that includes
  application data and IPv6 headers

* IoT is still vulnerbale to attacks that aim to disrupt the network

### IDS (Intrusion Detection System)
Detecting attacks against a system by analyzing the activity in the network or
in the system itself. It can be either **Signature Based** or **Anomaly
based**.

* **Signature based** detection matches the current behavior of the network
  against predefined attack patterns.
    - Needs extra storage to store attack signature.
    - Cannot detect new attacks

* **Anomaly based** detect anomalies by compaing to normal behavior
    - has high false positive and high false negative

* SVELTE targets:
    - Sink hole
    - selective forwarding
    - Spoofed
    - Altered routing information

* A while list is used here 
    - Easier in the presence of many attackers


## SVELTE: An IDS for the IoT
* Three main centralized modules we place in the 6BR
    - 6LoWPAN Mapper (6Mapper)

    - Internet Detection Component 
        - analyze mapped data and detects intrusion
    
    - Mini-firewall
        - offload nodes by filtering unwanted traffic before it enters the
          resource con- strained network

* Three lightweight modules in each constrained nodes
    - Mapping information to 6BR to perform intrusion detection
    - firewall module
    - end-to-end packet lost handler module

### 6LoWPAN Mapper
It reconstructs the routing graph (RPL DODAG) in router 6BR by sending mapping 
requests to nodes in the 6LoWPAN network.
* Request: (5 bytes)
    - information to identify an RPL DODAG.
    - RPL Instance ID
    - The DODAG ID
    - The DODAG verison number
    - timestamp
    - Total size of mapping request is 5 bytes

* Response: (13 bytes + 4 bytes * each neighbor)
    - Node ID
    - Node Rank
    - Parent ID
    - Neighbor ID
    - Neighbor Rank

##### Different Mappers
* 6Mapper with Authentic and Reliable Communication 
    - When the communication in the 6LoWPAN is authentic and reliable, the
      size of the 6Mapper request and response packets is reduced to 1 byte
      and 8 bytes, respectively.
* Unidirectional RPL 6Mapper
    - Some RPL implementations only support traffic destined to the DODAG root
    - it is possible to alter the 6Mapper and let it wait for the periodic
      mapping response packets from each node without sending the explicit
      request packet.
* Valid inconsistencies in 6Mapper
    - mapping responses are inconsistent with each other which can lead to 
      false positive

* Mapping requirements
    - Packets for mapping needs to be indistinguishable from other packets
      other wise adversaries can target the mapping packets to manipulate the
      topology in their own will. There are ways to prevent it:
        - Encrypt the data (provided by upper layer security protocols)
        - Header should not reveal information about the packet types
        - Assign as many IPv6 addresses to the 6Mapper as there are nodes in
          the network, so 6Mapper has multiple IP addresses and each of the 
          node mapps to one of the IP addresses 6Mapper has.

### Intrusion Detection in SVELTE
Detects:
* Spoofed or Altered information
* Sinkhole
* Selective forwarding
* Can be extended for more attacks

#### Network Graph Inconsistency Detection
Adversaries can use a compromised node to send wrong rank information to 
advertise a better route to destination.

Solution Idea:
* Detection uses the information stored in Mapper
* See if each node agrees with the ranking information of other nodes

However, we still need to distinguish between valid and invalid 
inconsistencies, there are two indicators that this papers use to make the 
judgement:
* The number of the reported faulty ranks
* The difference between the two reported ranks (using a threshold)

We once we encounter a large inconsistencies towards a node, the faulty
information corresponding to a node is corrected substituting its neighbor's
report

Once the system think the faulty node is compromised or attacked, we either
correct its rank or removes it from the white list

Once the system think the faulty node is compromised or attacked we can do
the following:
* correcting its rank and keep track of its inconsistencies record, if the same
  large inconsistencies occurs, it shall be removed.
* Removing it from the white list

#### Checking node Availability
Using a white list and filter list to keep track the current available nodes.
If the mapper has not received packet from a nodes for a long time, that means,
that very node is no longer available.

#### Routing Graph Validity
By artificially altering the routing graph, an attacker can reshape the 
topology of the network and can control the traffic flow to his advantage.

For solving this problem we keep track the number of occurrence of rank
inconsistency of each node. If the number of inconsistency occurs more than
a threshold, then the system will raise an alarm.

#### End to End Packet Loss Adaption
We design an intentionally simple system to take end to end losses into account when calculating the route and to mitigate the effects of filtering
hosts.

#### Sybil and CloneID attacks protection
They cannot really affect 6Mapper.

### Distributed mini-firewall
SVELTE can protect 6LoWPAN network against in-network intrusion, but we still
need to protect constrained nodes from global attackers. The firewall has a 
module in the 6BR and in the constrained nodes.
* Filter well-know external attackers
* filter external host in real time specified by the nodes inside 6LoWPAN
  Network.

Destination host inside network can see encrypted contents and analyze the
malicious traffic and notify the router in real-time.
