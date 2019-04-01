# Namespace NetworkPolicy Metacontroller controller

Networkpolicy applied based on Namespace annotations

annotation example (these go on a service object):

```
  annotations:
    network-zone: 'true'
    network-zone.additional-ports: 9999/TCP,8888/UDP
```

`network-zone: 'true'`- enable network-policy

`network-zone.additional-ports: 9999/TCP,8888/UDP` - allow ingress traffic on these ports/protocols

This controller uses the metacontroller framework.

# Deploy the metacontroller

```
oc adm new-project metacontroller
oc apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/metacontroller/master/manifests/metacontroller-rbac.yaml
oc apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/metacontroller/master/manifests/metacontroller.yaml
```

# Deploy the namespace controller
```
oc project metacontroller
oc create configmap port-np-controller --from-file=port-np-controller.jsonnet --dry-run -o yaml | oc apply --force -f-
oc apply -f port-np-controller.yaml
```

# Test

Create a test namespace

```
oc new-project test-port-networkpolicy
oc apply -f ./test-service.yaml
```

make sure a networkpolicy is created

```
oc get networkpolicy -n test-port-networkpolicy

NAME                                    POD-SELECTOR                  AGE
allow-from-port-np-controller-test-np   app=port-np-controller-test   37s
```
