class EntryCell < Cell::Rails
  def metadata(args)
    @entry = args[:entry]
    @history_uri = args[:history_uri]
    @approve_uri = args[:approve_uri]
    @disapprove_uri = args[:disapprove_uri]
    @edit_uri = args[:edit_uri]
    @destroy_url = args[:destroy_url]
    render
  end
end
