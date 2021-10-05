Pod::Spec.new do |spec|
    spec.name                   = 'Models'
    spec.version                = '1.0'
    spec.summary                = 'https://github.com/sergeykhliustin/buildio'

    spec.homepage               = 'https://github.com/sergeykhliustin/buildio'
    spec.author                 = { 'sergeykhliustin' => 'sergeykhliustin' }
    spec.source                 = { :source => './Models' }

    spec.static_framework       = true

    spec.ios.deployment_target  = '13.0'
    spec.osx.deployment_target  = '10.15'

    spec.source_files           = [
        'Models/**/*.{swift}',
    ]
end
