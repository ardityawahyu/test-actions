from diagrams import Cluster, Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.database import RDS
from diagrams.aws.network import ELB
from diagrams.gcp.database import SQL
from diagrams.gcp.network import LoadBalancing
from diagrams.gcp.storage import Storage
from diagrams.k8s.network import Service
from diagrams.k8s.compute import Pod
from diagrams.onprem.queue import Kafka, RabbitMQ
from diagrams.onprem.inmemory import Redis
from diagrams.onprem.network import HAProxy
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.monitoring import Grafana
from diagrams.onprem.logging import Loki
from diagrams.saas.logging import NewRelic

with Diagram("kampanye Architecture", show=False, outformat="svg"):
    with Cluster("Cloudflare"):
        proxy = HAProxy("WAF")
    with Cluster("AWS"):
        with Cluster("Kitabisa DB"):
            db_main = RDS("kitabisa-master")
            db_replica = RDS("kitabisa-replica")
            db_kitabisa = [db_main, db_replica]

        proxySQL = EC2("ProxySQL")
        proxySQL >> db_kitabisa

    with Cluster("GCP"):
        with Cluster("GKE"):
            kampanye = Pod("kampanye-server")
            kw_projects = Pod("worker-projects")
            kw_project_statuses = Pod("worker-project-statuses")
            kw_project_categories = Pod("worker-project-categories")
            redis = Redis("redis")
            kampanye >> Pod("steril")
            kampanye >> Pod("campaignership")
            kampanye >> Pod("wong")

        kafka = Kafka("kafka")
        db_kampanye = SQL("kampanye")

        db_replica >> kafka
        proxy >> kampanye >> db_kampanye
        kampanye >> proxySQL
        kafka >> kw_projects >> db_kampanye
        kafka >> kw_project_statuses >> db_kampanye
        kafka >> kw_project_categories >> db_kampanye

        kampanye >> redis
        kw_projects >> redis
        kw_project_statuses >> redis
        kw_project_categories >> redis
