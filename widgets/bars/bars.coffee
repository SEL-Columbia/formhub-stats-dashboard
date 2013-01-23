class Dashing.Bars extends Dashing.Widget

  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')
    points = @get('points')
    if points
      points[points.length - 1].y

  ready: ->
    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      series: [
        {
        color: "#fff",
        data: [{x: 0, y:0}]
        }
      ]
    )

    @graph.series[0].data = @get('points') if @get('points')

    x_axis = new Rickshaw.Graph.Axis.Time( { graph: @graph } );
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat:
            Rickshaw.Fixtures.Number.formatKMBT)

    @graph.render()

  onData: (data) ->
    if @graph
      # set renderer to bar here after we have some data to re-calculate bar
# widths
      @graph.series[0].data = data.points
      if@graph.renderer.name isnt 'bar'
        @graph.setRenderer('bar')
      @graph.render()
