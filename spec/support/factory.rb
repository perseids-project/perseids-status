module Factory
  def self.request_map
    args = [
      {
        url: 'https://apple.example.com',
        test: :fruit,
        name: :apple,
        compare: 'diff',
        canonical: 'apple',
        result: 'apple',
      },
      {
        url: 'https://pear.example.com',
        test: :fruit,
        name: :pear,
        compare: 'diff',
        canonical: 'pear',
        result: 'figs',
      },
      {
        url: 'https://carrot.example.com',
        test: :vegetable,
        name: :carrot,
        compare: 'wc',
        canonical: 'carrot',
        result: 'torrac',
      },
      {
        url: 'https://onion.example.com',
        test: :vegetable,
        name: :onion,
        compare: 'wc',
        canonical: 'onion',
        result: 'onions',
      },
    ]

    PerseidsStatus::RequestMap.new(args.map { |a| PerseidsStatus::Request.new(**a) })
  end

  def self.request_map_with_no_diffs
    args = [
      {
        url: 'https://apple.example.com',
        test: :fruit,
        name: :apple,
        compare: 'diff',
        canonical: 'apple',
        result: 'apple',
      },
      {
        url: 'https://pear.example.com',
        test: :fruit,
        name: :pear,
        compare: 'diff',
        canonical: 'pear',
        result: 'pear',
      },
      {
        url: 'https://carrot.example.com',
        test: :vegetable,
        name: :carrot,
        compare: 'wc',
        canonical: 'carrot',
        result: 'torrac',
      },
      {
        url: 'https://onion.example.com',
        test: :vegetable,
        name: :onion,
        compare: 'wc',
        canonical: 'onion',
        result: 'noino',
      },
    ]

    PerseidsStatus::RequestMap.new(args.map { |a| PerseidsStatus::Request.new(**a) })
  end

  def self.config
    {
      fruit: {
        apple: 'https://apple.example.com',
        pear: { url: 'https://pear.example.com' },
      },
      vegetable: {
        carrot: { url: 'https://carrot.example.com', compare: 'wc' },
        onion: { url: 'https://onion.example.com', compare: 'wc' },
      },
    }
  end

  def self.json
    [
      {
        location: 'comparison-2000-02-02T0000000Z',
        fruit: {
          apple: 'ok',
          pear: 'diff',
        },
        vegetable: {
          carrot: 'ok',
          onion: 'wc',
        },
      },
      {
        location: 'comparison-2000-01-02T0000000Z',
        fruit: {
          apple: 'ok',
          pear: 'ok',
        },
        vegetable: {
          carrot: 'ok',
          onion: 'ok',
        },
      },
    ]
  end

  def self.json_fixture_json
    [
      {
        location: 'comparison-time',
        fruit: {
          apple: 'ok',
          pear: 'diff',
        },
        vegetable: {
          carrot: 'ok',
          onion: 'wc',
        },
      },
      {
        location: 'comparison-2000-02-02T0000000Z',
        fruit: {
          apple: 'ok',
          pear: 'diff',
        },
        vegetable: {
          carrot: 'ok',
          onion: 'wc',
        },
      },
      {
        location: 'comparison-2000-01-02T0000000Z',
        fruit: {
          apple: 'ok',
          pear: 'ok',
        },
        vegetable: {
          carrot: 'ok',
          onion: 'ok',
        },
      },
    ]
  end
end
