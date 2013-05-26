class EntryCell < Cell::Rails
  def metadata(args)
    @entry = args[:entry]
    @history_uri = args[:history_uri]
    @edit_uri = args[:edit_uri]
    render
  end
end
