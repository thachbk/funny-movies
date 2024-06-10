module ApiRoutes
  def self.extended(router)
    router.instance_exec do
      namespace :api do
        api_version(module: 'V1', header: { name: 'X-API-VERSION', value: 'v1' }) do
          resources :trading_accounts, only: %i[show] do
            member do
              resources :charts, only: %i[] do
                collection do
                  get :balance_equity
                  get :profit_daily
                  get :profit_weekly
                  get :profit_monthly
                  get :profit_yearly
                end
              end

              resources :trading_activities, only: %i[index]
            end
          end
        end
      end
    end
  end
end