
defmodule Sn22Web.Ac do
  alias Sn22Web.Presence
  use Sn22Web, :live_view
  alias Phoenix.Socket.Broadcast

  def mount(p, %{"user" => user}, socket) do
    if connected?(socket), do:

    Phoenix.PubSub.subscribe(Sn22.PubSub, "ac")
    {:ok, u} = M7state.get_user(user);
    :timer.send_interval(25, {:update, u})

    updated =
      socket
      |> assign(:acc, M7state.get.inc.ymn)
      |> assign(:ex, u.ex)
      |> assign(:label, Jason.encode! %{"a" => user})
      |> assign(:us, M7state.get.users)
      |> assign(:b, M7state.get.b)
      |> assign(:c, M7state.get.c)
      |> assign(:chips, M7state.get.chips)
      |> assign(:ua, u.a)
      |> assign(:ub, u.b)

    {:ok, updated}
  end

  def handle_info({:update, u}, socket) do

    {:noreply, socket
    |> assign(:acc, M7state.get.inc.ymn)
    |> assign(:chips, M7state.get.chips)

    |> assign(:b, M7state.get.b)
    |> assign(:us, M7state.get.users)
    |> assign(:c, M7state.get.c)
    |> assign(:ex, u.ex)


  }
  end

def render(assigns) do
    ~H"""
        <%= (inspect @c)%>
<br>
    <%= ( :erlang.float_to_binary(@b, [decimals: 2])) <>" p"%>

    <br>

<%= for {k,v} <- @ex do %>
  <span class="name"><%= "#{k}, #{v}__" %></span>
<% end %>

<br>
<form method="POST" action="https://yoomoney.ru/quickpay/confirm.xml">
    <input type="hidden" name="receiver" value="4100117845246172"/>
    <input type="hidden" name="label" value="1111"/>
    <input type="hidden" name="quickpay-form" value="button"/>
    <input placeholder="...0 p" name="sum" value={""} type='number' min="1" max="99999" step="0.01"/>
    <%!-- <label><input type="radio" name="paymentType" value="PC"/>ЮMoney</label>
    <label><input type="radio" name="paymentType" value="AC"/>Банковской картой</label> --%>
    <%!-- <input  type="submit" disabled="true" value="пк"/> --%>
    <input  type="submit"  value="пк"/>
</form>

<%= for {k,v} <- @us do %>
  <span class="name"><%= "#{v.id}, #{v.a}, #{v.b}__" %></span>
<% end %>

  <%= for m <- @acc do %>
  <div class="name"><%= inspect m %></div>
<% end %>
<br>
    <%= (inspect @chips) <>""%>

    <div class="contentarea">
  <h1>MDN - navigator.mediaDevices.getUserMedia(): Still photo capture demo</h1>
  <p>
    This example demonstrates how to set up a media stream using your built-in
    webcam, fetch an image from that stream, and create a PNG using that image.
  </p>
  <div class="camera">
    <video id="video">Video stream not available.</video>
    <button id="startbutton">Take photo</button>
  </div>
  <canvas id="canvas"> </canvas>
  <div class="output">
    <img id="photo" alt="The screen capture will appear in this box." />
  </div>
  <p>
    Visit our article
    <a
      href="https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API/Taking_still_photos">
      Taking still photos with WebRTC</a>

    to learn more about the technologies used here.
  </p>
</div>


  <script>
  (() => {
  // The width and height of the captured photo. We will set the
  // width to the value defined here, but the height will be
  // calculated based on the aspect ratio of the input stream.

  const width = 320; // We will scale the photo width to this
  let height = 0; // This will be computed based on the input stream

  // |streaming| indicates whether or not we're currently streaming
  // video from the camera. Obviously, we start at false.

  let streaming = false;

  // The various HTML elements we need to configure or control. These
  // will be set by the startup() function.

  let video = null;
  let canvas = null;
  let photo = null;
  let startbutton = null;

  function showViewLiveResultButton() {
    if (window.self !== window.top) {
      // Ensure that if our document is in a frame, we get the user
      // to first open it in its own tab or window. Otherwise, it
      // won't be able to request permission for camera access.
      document.querySelector(".contentarea").remove();
      const button = document.createElement("button");
      button.textContent = "View live result of the example code above";
      document.body.append(button);
      button.addEventListener("click", () => window.open(location.href));
      return true;
    }
    return false;
  }

  function startup() {
    if (showViewLiveResultButton()) {
      return;
    }
    video = document.getElementById("video");
    canvas = document.getElementById("canvas");
    photo = document.getElementById("photo");
    startbutton = document.getElementById("startbutton");

    navigator.mediaDevices
      .getUserMedia({ video: true, audio: false })
      .then((stream) => {
        video.srcObject = stream;
        video.play();
      })
      .catch((err) => {
        console.error(`An error occurred: ${err}`);
      });

    video.addEventListener(
      "canplay",
      (ev) => {
        if (!streaming) {
          height = video.videoHeight / (video.videoWidth / width);

          // Firefox currently has a bug where the height can't be read from
          // the video, so we will make assumptions if this happens.

          if (isNaN(height)) {
            height = width / (4 / 3);
          }

          video.setAttribute("width", width);
          video.setAttribute("height", height);
          canvas.setAttribute("width", width);
          canvas.setAttribute("height", height);
          streaming = true;
        }
      },
      false
    );

    startbutton.addEventListener(
      "click",
      (ev) => {
        takepicture();
        ev.preventDefault();
      },
      false
    );

    clearphoto();
  }

  // Fill the photo with an indication that none has been
  // captured.

  function clearphoto() {
    const context = canvas.getContext("2d");
    context.fillStyle = "#AAA";
    context.fillRect(0, 0, canvas.width, canvas.height);

    const data = canvas.toDataURL("image/png");
    photo.setAttribute("src", data);
  }

  // Capture a photo by fetching the current contents of the video
  // and drawing it into a canvas, then converting that to a PNG
  // format data URL. By drawing it on an offscreen canvas and then
  // drawing that to the screen, we can change its size and/or apply
  // other changes before drawing it.

  function takepicture() {
    const context = canvas.getContext("2d");
    if (width && height) {
      canvas.width = width;
      canvas.height = height;
      context.drawImage(video, 0, 0, width, height);

      const data = canvas.toDataURL("image/png");
      photo.setAttribute("src", data);
    } else {
      clearphoto();
    }
  }

  // Set up our event listener to run the startup process
  // once loading is complete.
  window.addEventListener("load", startup, false);
})();



</script>

    """
  end
end
