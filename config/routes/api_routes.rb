module ApiRoutes
  def self.extended(router)
    router.instance_exec do
      namespace :api do
        api_version(module: 'V1', header: { name: 'X-API-VERSION', value: 'v1' }) do
          resources :videos, only: %i[index create]
        end
      end
    end
  end
end
