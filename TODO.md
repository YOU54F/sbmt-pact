```

bundle exec rspec -t pact spec/pact/providers/sbmt-pact-test-app/kafka_spec.rb
bundle exec rspec -t pact spec/pact/consumers/kafka_spec.rb
rm spec/internal/pacts/sbmt-pact-test-app-sbmt-pact-test-app.json
bundle exec rspec -t pact spec/pact/providers/sbmt-pact-test-app/http_client_spec.rb
bundle exec rspec -t pact spec/pact/consumers/http_spec.rb
rm spec/internal/pacts/sbmt-pact-test-app-sbmt-pact-test-app.json
bundle exec rspec -t pact spec/pact/providers/sbmt-pact-test-app/grpc_client_spec.rb
bundle exec rspec -t pact spec/pact/consumers/grpc_spec.rb
rm spec/internal/pacts/sbmt-pact-test-app-sbmt-pact-test-app.json
```