defmodule Identicon do

  @doc """
  Generate and identicon based on a string input.
  """

  def generate(input) do
    String.trim(input)
    |> hash
    |> pickColor
    |> buildGrid
    |> filterOddSquares
    |> buildPixelMap
    |> createImage
    |> saveImage(input)
  end

  defp hash(input) do
    hex = :crypto.hash(:md5, input)
          |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  defp pickColor(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  defp buildGrid(%Identicon.Image{hex: hex} = image) do
    grid = hex
           |> Enum.chunk(3)
           |> Enum.map(&mirrorRow/1)
           |> List.flatten
           |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  defp filterOddSquares(%Identicon.Image{grid: grid} = image) do
    evenGrid = Enum.filter grid, fn {num, _index} ->
      rem(num, 2) == 0
    end

    %Identicon.Image{image | grid: evenGrid}
  end

  defp buildPixelMap(%Identicon.Image{grid: grid} = image) do
    pixelMap = grid
    |> Enum.map(fn {_, index} -> indexToSquare(index) end)

    %Identicon.Image{image | grid: pixelMap}
  end

  defp indexToSquare(index) do
    x = rem(index, 5) * 50
    y = div(index, 5) * 50
    topLeft = {x,y}
    bottomRight = {x + 50, y + 50}

    { topLeft, bottomRight }
  end

  defp createImage(%Identicon.Image{grid: grid, color: color}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each grid, fn {topLeft, bottomRight} ->
      :egd.filledRectangle(image, topLeft, bottomRight, fill)
    end

    :egd.render(image)
  end

  def saveImage(imageData, filename) do
    File.write("#{filename}.png", imageData)
  end

  defp mirrorRow(row) do
    len = length(row)
    row ++ (
      Enum.take(row, len - 1)
      |> Enum.reverse)
  end
end
