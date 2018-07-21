# Identicon generator

This project generates identicon images from strings. Identicon images are small avatars that github uses for people
who do not upload an avatar themselves. Some examples:

![elixir](examples/elixir.png)
![erlang](examples/erlang.png)
![marcsi](examples/marcsi.png)
![nagyf](examples/nagyf.png)
![jane doe](examples/jane doe.png)
![john doe](examples/john doe.png)

## Usage

```
iex> Identicon.generate("example")
:ok
```

The image will be generated in the same folder, with the string as the name of the image.