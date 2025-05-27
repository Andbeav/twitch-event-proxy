function setupTESForwarding(tes_config, subscriptions, proxy_socket) {
    const tes = new TES(tes_config);

    Object.keys(subscriptions).forEach((subscription) => {
        tes.on(subscription, (event) => {
            event.subscription_type = subscription
            proxy_socket.send(JSON.stringify(event));
        });

        tes.subscribe(subscription, subscriptions[subscription].conditions)
            .then(() => {
                console.log(`Successfully subscribed to event: ${subscription}`);
            }).catch((err) => {
                console.log(`Failed to subscribe to event: ${subscription}`);
                console.log(err);
            });
    });
}

function setupProxy(config, subscriptions) {
    const subscription_types = Object.keys(subscriptions);
    const proxy_socket = new WebSocket(config.proxy_socket_uri);

    setupTESForwarding(config.tes, subscriptions, proxy_socket);

    proxy_socket.addEventListener("message", (event) => {
        const data = JSON.parse(event.data);

        if (subscription_types.includes(data.subscription_type)) {
            subscriptions[data.subscription_type].callback(data);
        }
    });
}
