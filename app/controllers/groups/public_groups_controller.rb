class Groups::PublicGroupsController < BaseController
  before_filter :authenticate_user!, except: [:index]

  def index
    if params[:query]
      @groups = Group.visible_to_the_public.
                search_full_name(params[:query]).
                page(params[:page])
    else
      @groups = Group.visible_to_the_public.page(params[:page])
    end
    case params[:order]
    when 'namesA-Z'
      @ordered_groups = @groups.sort_by!{ |g| g.name }
      @name_order = "A-Z"
    when 'namesZ-A'
      @ordered_groups = @groups.sort_by{ |g| g.name }.reverse!
      @name_order = "Z-A"
    when 'members1-9'
      @ordered_groups = @groups.sort_by!{ |g| g.memberships_count }
      @member_count_order = "1-9"
    when 'members9-1'
      @ordered_groups = @groups.sort_by{ |g| g.memberships_count }.reverse!
      @member_count_order = "9-1"
    else
      @ordered_groups = @groups
    end
  end
end
