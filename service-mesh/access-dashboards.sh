#!/bin/bash

# Open Kiali dashboard
echo "Opening Kiali dashboard..."
istioctl dashboard kiali &

# Open Grafana dashboard
echo "Opening Grafana dashboard..."
istioctl dashboard grafana &

# Open Prometheus dashboard
echo "Opening Prometheus dashboard..."
istioctl dashboard prometheus &

# Open Jaeger dashboard
echo "Opening Jaeger dashboard..."
istioctl dashboard jaeger &

echo "Press Ctrl+C to close all dashboards when finished."
wait
