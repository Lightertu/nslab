# Comparison between 6Lowpan, Zigbee, and Z-Wave

* 6Lowpan:
    - Pros:
        - It uses IPv6 protocol, therefore it can directly talk to Internet Based devices
        - Requires less RAM and ROM then Zigbee
        - Does not have to go through a ZigBee to IP translation step
        - Better interoperability, it can connect to other wireless 802.15.4 devices and
          devices on other IP network using a bridge device. 

* Zigbee:
    - Pros:
        - More popular
        - More support from hardware vendors
        - Can be bridged to alljoyn
        - Zigbee IP ?
        - Better documentation and tutorials

    - Con:
        - Zigbee devices can only talk to zigbee devices, talking to none-zigbee devices
          requires complex application layer gateway
