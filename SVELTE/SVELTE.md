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


