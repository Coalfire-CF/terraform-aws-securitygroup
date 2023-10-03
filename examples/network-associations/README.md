## Security Group module network association example

One of the prerequisites of the security group module is that it is capable of creating network associations on its own.

This example should create three (3) EC2 instances, two of which will be attached to the security group by the module itself, and the third will attach the security group inline.

Any resource that has a network interface attached to it can input the ID of the network interface in order to make an association.

NOTE: Using the security group to associate a network interface that is attached to an instance that has already associated itself with the security group in its declaraction WILL NOT WORK.