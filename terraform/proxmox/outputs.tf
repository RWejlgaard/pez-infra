output "control_plane_ip" {
  description = "Static IP of the k3s control-plane VM."
  value       = var.control_plane_ip
}

output "control_plane_vm_id" {
  value = proxmox_virtual_environment_vm.k3s_server.vm_id
}

output "worker_template_vm_id" {
  description = "Template VM id kproximate clones (set as kpNodeTemplateName/id)."
  value       = proxmox_virtual_environment_vm.k3s_agent_template.vm_id
}
