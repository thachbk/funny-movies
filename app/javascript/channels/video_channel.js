import consumer from "./consumer"

consumer.subscriptions.create("VideoChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("connected")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("disconnected")
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("received")
    console.log(data)

    // show popup modal here
    const modal = new bootstrap.Modal(document.getElementById('shareRecipeModal'), {  keyboard: false })
    modal.show()

    // update modal content
    document.getElementById('videoTitleModal').innerText = data.title
    document.getElementById('videoOwnerModal').innerText = data.user_email
  }
});
