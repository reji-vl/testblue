resource "azurerm_resource_group" "blue_whale"{
	name = "Whaleprogram"
	location = var.loca
}

resource "azurerm_virtual_network" "blue_net"{
	name = "blue_network"
	resource_group_name = azurerm_resource_group.blue_whale.name
	address_space = ["10.0.10.0/24"]
	location = var.loca
	dns_servers = ["10.0.0.4","10.0.0.5"]
}

resource  "azurerm_subnet" "blue_sub" {
	name = "bluesub"
	resource_group_name = azurerm_resource_group.blue_whale.name
	virtual_network_name = azurerm_virtual_network.blue_net.name
	address_prefix = "10.0.10.0/24"
}

resource "azurerm_network_interface" "blue_face"{
	name = "blueface"
	resource_group_name = azurerm_resource_group.blue_whale.name
	location = var.loca
	
	ip_configuration {
		name = "bluenic1"
		subnet_id = "${azurerm_subnet.blue_sub.id}"
		private_ip_address_allocation = "Dynamic"		
	}
	tags = {
		environment = "staging"
	}
}

resource "azurerm_virtual_machine" "blue_machine"{
	name = "bluemachine"
	resource_group_name = azurerm_resource_group.blue_whale.name
	location = var.loca
	network_interface_ids = ["${azurerm_network_interface.blue_face.id}"]
	vm_size = "Standard_DS1_v2"
	
	os_profile_linux_config {
		disable_password_authentication = false
	}
	os_profile {
		computer_name = "blueserver"
		admin_username = "blueadmin"
		admin_password = "Test@123"
	}
	
	storage_os_disk { 
		name = "bluevmosdisk"
		create_option = "FromImage"
		caching = "ReadWrite"
		disk_size_gb = 30
	}
	
	storage_image_reference {
		publisher = "Canonical"
		offer     = "UbuntuServer"
		sku       = "16.04-LTS"
		version   = "latest"
	}
}
