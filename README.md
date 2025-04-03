# 🚀 echo-lb

A local Kubernetes cluster setup for macOS (M1/M2) using **Colima**, **Kind**, and **Cilium**, with a sample Echo service from HashiCorp exposed via a local LoadBalancer.

Once complete, you'll have an Echo service available at:  
👉 **https://echo.echo-lb.kube**

This setup provides local LoadBalancer IP allocation that maps directly to `localhost`, making it ideal for testing production-like networking behavior in a local dev environment.

---

## 🛠️ What’s Inside

This project includes:

- A local Kubernetes cluster powered by **Kind** and **Colima**
- **Cilium** as the CNI and service mesh
- A simple **Echo service** for testing
- Local **DNS resolution**
- Self-signed **TLS certificates**

> **Note:** Command files are named with a `.sh` extension, but they’re not actual shell scripts.  
> Copy and paste the commands into your terminal to execute them.

---

## 📋 Setup Order

To get everything up and running, follow these steps **in order**:

1. **Colima** – Launch the container runtime
2. **Kind** – Create the Kubernetes cluster
3. **Cilium** – Install the CNI and gateway api
4. **Echo** – Deploy the Echo app
5. **DNS** – Enable local DNS for custom domains
6. **Certificates** – Add HTTPS support

---

## 📖 Full Guide

For a detailed walkthrough, including explanations of each step and troubleshooting tips,  
📘 [Read the full article here](#)

---
