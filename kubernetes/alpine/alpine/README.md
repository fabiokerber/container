# Kubernetes > Alpine

**Vbox**<br>
https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vboxmanage-modifyvm.html<br>
<br />

**Alpine Linux**<br>
https://wiki.alpinelinux.org/wiki/Installation#Installation_Handbook<br>
https://wiki.alpinelinux.org/wiki/Configure_Networking<br>
https://wiki.alpinelinux.org/wiki/Repositories#Enabling_the_community_repository<br>
https://wiki.alpinelinux.org/wiki/VirtualBox_guest_additions<br>
https://softwaretester.info/create-alpine-linux-vm-with-virtualbox/<br>
https://akos.ma/blog/alpine-linux-in-virtualbox/<br>
https://www.cyberciti.biz/faq/how-to-enable-and-start-services-on-alpine-linux/<br>
<br />

**Kubernetes**<br>
https://docs.k3s.io/cli/token<br>
https://pet2cattle.com/2021/04/k3s-join-nodes<br>
https://techviewleo.com/install-kubernetes-on-alpine-linux-with-k3s/<br>
https://www.rancher.co.jp/docs/k3s/latest/en/installation/<br>
https://www.fullstaq.com/knowledge-hub/blogs/setting-up-your-own-k3s-home-cluster<br>
https://www.virtualizationhowto.com/2022/05/traefik-ingress-example-yaml-and-setup-in-k3s/<br>
https://octopus.com/blog/difference-clusterip-nodeport-loadbalancer-kubernetes<br>
https://github.com/k3s-io/k3s/issues/1381<br>
https://computingforgeeks.com/install-and-use-helm-3-on-kubernetes-cluster/<br>
https://blog.devops.dev/kubernetes-run-nginx-containers-using-yaml-file-a37c115caf7e<br>
https://platform9.com/learn/v1.0/tutorials/nginix-controller-helm#install%20NGINX%20using%20Helm%203<br>
https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing<br>
https://blog.elo7.dev/subindo-uma-aplicacao-no-kubernetes-usando-helm/<br>
https://github.com/rancher/rancher/issues/26407<br>
<br />

**Kube State Metrics**<br>
https://github.com/kubernetes/kube-state-metrics/tree/main/examples/standard<br>
<br />

**Helm**<br>
https://gist.github.com/icebob/958b6aeb0703dc24f436ee8945f0794f<br>
<br />

**Firewall**<br>
https://www.cyberciti.biz/faq/how-to-set-up-a-firewall-with-awall-on-alpine-linux/<br>
https://www.linuxshelltips.com/setup-awall-firewall-alpine-linux/<br>
https://wiki.alpinelinux.org/wiki/Setting_up_Transparent_Content_Filter_on_Gateway_with_Privoxy<br>
<br />

**Prometheus**<br>
https://observability.thomasriley.co.uk/introduction/<br>
https://devopscounsel.com/monitoring-kubernetes-cluster-with-prometheus/<br>
https://devopscounsel.com/prometheus-node-exporter-setup-on-kubernetes/<br>
https://devopscounsel.com/grafana-setup-for-prometheus-server-on-kubernetes/<br>
<br />

**Prometheus Federation**<br>
https://levelup.gitconnected.com/federating-prometheus-effectively-4ccd51b2767b<br>
https://prometheus.io/docs/prometheus/latest/federation/<br>
<br />

**Prometheus Service Alpine**<br>
https://prometheus.io/download/<br>
https://devopscube.com/install-configure-prometheus-linux/<br>
<br />

**Prometheus Add New Target**<br>
https://www.server-world.info/en/note?os=Ubuntu_18.04&p=prometheus&f=2<br>
<br />

**Prometheus Node-Exporter**<br>
https://github.com/prometheus/node_exporter<br>

**Alpine Node-Exporter ISSUE**<br>
https://ixday.github.io/post/shared_mount/<br>
https://unix.stackexchange.com/questions/442020/alpine-linux-run-a-startup-script-to-change-the-etc-issue<br>
https://unix.stackexchange.com/questions/659941/what-do-mount-slave-and-rslave-option-do<br>
<br />

**PostgreSQL**<br>
https://phoenixnap.com/kb/postgresql-kubernetes<br>
<br />

**Grafana Dashboards**<br>
https://grafana.com/grafana/dashboards/6417-kubernetes-cluster-prometheus/<br>
https://grafana.com/grafana/dashboards/315-kubernetes-cluster-monitoring-via-prometheus/<br>
https://github.com/dotdc/grafana-dashboards-kubernetes<br>
https://grafana.com/grafana/dashboards/8588-1-kubernetes-deployment-statefulset-daemonset-metrics/<br>
https://grafana.com/grafana/dashboards/1860-node-exporter-full/<br>
https://grafana.com/grafana/dashboards/13838-kubernetes-overview/<br>
https://grafana.com/grafana/dashboards/15172-node-exporter-for-prometheus-dashboard-based-on-11074/<br>
https://grafana.com/grafana/dashboards/11074-node-exporter-for-prometheus-dashboard-en-v20201010/<br>
https://grafana.com/grafana/dashboards/162-kubernetes-pod-monitoring/<br>
https://grafana.com/grafana/dashboards/8919-1-node-exporter-for-prometheus-dashboard-cn-0413-consulmanager/<br>
https://grafana.com/grafana/dashboards/16098-1-node-exporter-for-prometheus-dashboard-cn-0417-job/<br>
<br />

**JSON Formatter**<br>
https://jsonformatter.curiousconcept.com/<br>
<br />

**AlertManager**<br>
https://grafana.com/blog/2020/02/25/step-by-step-guide-to-setting-up-prometheus-alertmanager-with-slack-pagerduty-and-gmail/<br>
https://devopscounsel.com/alertmanager-setup-on-kubernetes-for-prometheus-monitoring/<br>
https://itnext.io/prometheus-configuration-with-custom-alert-labels-for-platform-and-application-level-alerts-4a356ed2488d<br>
<br />

**Alpine Services**<br>
https://github.com/OpenRC/openrc/blob/master/service-script-guide.md<br>
https://serverfault.com/questions/974686/converting-a-systemd-service-to-openrc-alpine-linux<br>
https://wiki.gentoo.org/wiki/Handbook:AMD64/Working/Initscripts#Writing_initscripts<br>
<br />

```
$ bash create-alpine-vm.sh
```

## firewall

```
- Install

setup-alpine
Select keyboard layout: pt
Select variant: pt
Enter system hostname: firewall1.fks.lab
Which one do you want to initialize: eth1, dhcp
Which one do you want to initialize: eth0, none, y
  auto lo
  iface lo inet loopback

  auto eth1
  iface eth1 inet dhcp

  auto eth0
  iface eth0 inet static
    address 192.168.56.200/24

New password:
Which timezone are you in: Portugal
HTTP/FTP proxy URL: none
Which NTP client to run: chrony
Enter mirror number or URL do add: 1
Setup a user: no
Which ssh server: openssh
Allow root ssh login: yes
Enter ssh key or URL for root: none

Which disk(s) would you like to use: sda
How would you like to use it: sys
WARNING: Erase the above disk(s) and continue: y

# halt
```

## all except firewall
```
- Install

setup-alpine
Select keyboard layout: pt
Select variant: pt
Enter system hostname: kmaster1.fks.lab / ..
Which one do you want to initialize: eth0, none, y
  auto lo
  iface lo inet loopback

  auto eth0
  iface eth0 inet static
    address 192.168.56.{..}/24
    gateway 192.168.56.200

DNS domain name: fks.lab
DNS nameserver(s): 8.8.8.8 8.8.4.4
New password:
Which timezone are you in: Portugal
HTTP/FTP proxy URL: none
Which NTP client to run: chrony
Enter mirror number or URL do add: 1
Setup a user: no
Which ssh server: openssh
Allow root ssh login: yes
Enter ssh key or URL for root: none

Which disk(s) would you like to use: sda
How would you like to use it: sys
WARNING: Erase the above disk(s) and continue: y

# halt
```

## K8s
```
kubectl get nodes
kubectl get all -A
kubectl top nodes
```

## backup
```
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--tls-san 192.168.56.150" sh -s -

VBoxManage modifyvm "$FW_NAME"$i.fks.lab --nic2 bridged --nictype2 82540EM --bridgeadapter2 "$FW_NET" --nicpromisc2 allow-all
VBoxManage modifyvm "$VM_NAME" --nic1 hostonly --hostonlyadapter1 vboxnet0 --nicpromisc1 allow-all
VBoxManage modifyvm "$VM_NAME" --nic2 nat

iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables -X
iptables -t nat -v -L POSTROUTING -n --line-number
iptables -t nat -D POSTROUTING 1
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 443

$(hostname -i | awk '{print $2}')

helm upgrade --install ingress-nginx ingress-nginx \
--repo https://kubernetes.github.io/ingress-nginx \
--version v4.2.5 \
--namespace ingress-nginx --create-namespace \
--set controller.kind=DaemonSet --set controller.service.type=NodePort --set controller.hostPort.enabled=true

kubectl describe pod -n monitoring

apk add --no-cache --upgrade grep

kill "$(netstat -lnp | grep 9090 | awk '{print $7}' | cut -f1 -d '/')"
```

## extra
```
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
curl -L --remote-name-all https://dl.k8s.io/release/v1.25.7/bin/linux/amd64/{kubeadm,kubelet} #version = https://get.k3s.io
chmod +x kube* && mv kube* /usr/local/bin

# k3s old version
curl -sfL https://github.com/rancher/k3s/releases/download/v1.25.7+k3s1/k3s -o /usr/local/bin/k3s && chmod 0755 /usr/local/bin/k3s
curl -sfL https://get.k3s.io -o install-k3s.sh && chmod 0755 install-k3s.sh
export INSTALL_K3S_SKIP_DOWNLOAD=true
./install-k3s.sh
reboot

k3s agent --server https://192.168.56.150:6443 --token <cluster-token>
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.150:6443 K3S_TOKEN="<node-token>" sh -

## add kubernetes masters (kmaster2 & kmaster3)
swapoff -a && sed -i '/swap/d' /etc/fstab
mkdir -p $HOME/.kube && vi $HOME/.kube/config
echo "export KUBECONFIG=$HOME/.kube/config" >> /etc/profile && . /etc/profile
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --server https://192.168.56.151:6443 --token k3s-fks-lab" sh -s -

## deploy kubernetes cluster (kmaster1)
sed -e '/server \\/,$d' -e 's@ExecStart=.*@ExecStart=/usr/local/bin/k3s server@' -i /etc/systemd/system/k3s.service
```

## deploy prometheus alpine 
```
wget https://github.com/prometheus/prometheus/releases/download/v2.43.1/prometheus-2.43.1.linux-amd64.tar.gz -O /tmp/prometheus-2.43.1.linux-amd64.tar.gz
tar -xvzf /tmp/prometheus-2.43.1.linux-amd64.tar.gz && mv prometheus-2.43.1.linux-amd64 prometheus-files
adduser -H -s /bin/false prometheus
mkdir /etc/prometheus && mkdir /var/lib/prometheus
cp prometheus-files/prometheus /usr/local/bin/ && cp prometheus-files/promtool /usr/local/bin/ 
cp -r prometheus-files/consoles /etc/prometheus && cp -r prometheus-files/console_libraries /etc/prometheus
chown prometheus:prometheus /usr/local/bin/prometheus && chown prometheus:prometheus /usr/local/bin/promtool
chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries
chown prometheus:prometheus /etc/prometheus/prometheus.yml
vi /etc/prometheus/prometheus.yml (wget from github)
--
global:
  scrape_interval: 10s

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
--
vi /etc/init.d/prometheus (wget from github)
--
#!/sbin/openrc-run

name=$RC_SVCNAME
command="/usr/local/bin/prometheus"
command_args="--config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries"
command_user="root:root"
pidfile="/run/$RC_SVCNAME/$RC_SVCNAME.pid"
#start_stop_daemon_args="--args-for-start-stop-daemon"

depend() {
        after network-online
}

#start() {
#       ebegin "Starting myApp"
#}

#stop() {
#       kill "$(netstat -lnp | grep 9090 | awk '{print $7}' | cut -f1 -d '/')"
#}

#
#--------------------------------
#
#[Unit]
#Description=signal-web-gateway daemon
#After=network.target
#
#[Service]
#PIDFile=/run/signal-web-gateway/pid
#User=signal
#Group=signal
#RuntimeDirectory=signal-web-gateway
#WorkingDirectory=/home/signal/
#ExecStart=/home/signal/signal -gateway -bind 127.0.0.1:5010
#PrivateTmp=true
#
#[Install]
#WantedBy=multi-user.target
#
#--------------------------------
#[Unit]
#Description=Prometheus
#Wants=network-online.target
#After=network-online.target
#
#[Service]
#User=prometheus
#Group=prometheus
#Type=simple
#ExecStart=/usr/local/bin/prometheus \
#    --config.file /etc/prometheus/prometheus.yml \
#    --storage.tsdb.path /var/lib/prometheus/ \
#    --web.console.templates=/etc/prometheus/consoles \
#    --web.console.libraries=/etc/prometheus/console_libraries
#
#[Install]
#WantedBy=multi-user.target
--
chmod +x /etc/init.d/prometheus
rc-service prometheus start | /etc/init.d/prometheus start
```

## prometheus federation (prometheus-config.yaml)
```
    scrape_configs:
      - job_name: 'federate'
        scrape_interval: 20s
        scrape_timeout: 20s
        honor_labels: true
        metrics_path: '/federate'
        params:
          'match[]':
            - '{__name__=~"kube_.*|node_.*|container_.*|local_.*"}'
        static_configs:
        - targets: ['192.168.56.162:30000']
```