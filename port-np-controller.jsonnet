function(request) {
  local service = request.object,
  local additionalPorts = std.split(service.metadata.annotations["network-zone.additional-ports"],","), 

  // Create a networkpolicy for each service.
  attachments: [
  {
      apiVersion: "networking.k8s.io/v1",
      kind: "NetworkPolicy",
      metadata: {
        name: "allow-from-" + service.metadata.name + "-np"
      },
      spec: {
        podSelector: {
          matchLabels: service.spec.selector
        },  
        ingress: [
          {
            ports: [
              {
                protocol: port.protocol,
                port: port.targetPort,
              }
              for port in service.spec.ports
            ]
          },
          {  
            ports: [ 
              {
                protocol: std.split(port, "/")[1],
                port: std.parseInt(std.split(port, "/")[0]),
              }
              for port in additionalPorts
            ]
          }  
        ]
      }
    }
  ]
}
